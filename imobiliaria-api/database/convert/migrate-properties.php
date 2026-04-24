<?php

/**
 * Migração de Imóveis e Imagens: PostgreSQL → MariaDB
 *
 * Execute via terminal: php migrate-properties.php
 */

// ─────────────────────────────────────────────
// CONFIGURAÇÕES DE CONEXÃO
// ─────────────────────────────────────────────

$pgConfig = [
    'host'     => 'br61-cp.valueserver.com.br',
    'port'     => '5432',
    'dbname'   => 'agen0808_imobipro',
    'user'     => 'agen0808_imobi_user',
    'password' => '0X4tlmxMR0JBsb8E',
];

$mysqlConfig = [
    'host'     => 'br606.hostgator.com.br',
    'port'     => '3306',
    'dbname'   => 'kgsweb_karina_corretora',
    'user'     => 'kgsweb_karina_corret',
    'password' => 'Mjd3246WGCj2SHYo',
    'charset'  => 'utf8mb4',
];

// ─────────────────────────────────────────────
// FUNÇÕES AUXILIARES
// ─────────────────────────────────────────────

function log_msg(string $msg, string $type = 'INFO'): void
{
    $time  = date('H:i:s');
    $color = match ($type) {
        'OK'    => "\033[32m",  // verde
        'ERRO'  => "\033[31m",  // vermelho
        'AVISO' => "\033[33m",  // amarelo
        default => "\033[36m",  // ciano
    };
    echo "{$color}[{$time}] [{$type}] {$msg}\033[0m\n";
}

function conectar_postgres(array $cfg): PDO
{
    $dsn = "pgsql:host={$cfg['host']};port={$cfg['port']};dbname={$cfg['dbname']}";
    $pdo = new PDO($dsn, $cfg['user'], $cfg['password'], [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    log_msg('Conectado ao PostgreSQL.', 'OK');
    return $pdo;
}

function conectar_mysql(array $cfg): PDO
{
    $dsn = "mysql:host={$cfg['host']};port={$cfg['port']};dbname={$cfg['dbname']};charset={$cfg['charset']}";
    $pdo = new PDO($dsn, $cfg['user'], $cfg['password'], [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    log_msg('Conectado ao MariaDB.', 'OK');
    return $pdo;
}

function normalizar_booleano(mixed $valor): int
{
    if (is_bool($valor)) return $valor ? 1 : 0;
    return in_array($valor, ['t', 'true', '1', 1, true], true) ? 1 : 0;
}

function normalizar_decimal(?string $valor): ?string
{
    if ($valor === null) return null;
    // PostgreSQL pode retornar notação científica ou vírgula
    return number_format((float) $valor, 8, '.', '');
}

// ─────────────────────────────────────────────
// CONEXÕES
// ─────────────────────────────────────────────

try {
    $pg    = conectar_postgres($pgConfig);
    $mysql = conectar_mysql($mysqlConfig);
} catch (PDOException $e) {
    log_msg('Falha ao conectar: ' . $e->getMessage(), 'ERRO');
    exit(1);
}

// ─────────────────────────────────────────────
// MIGRAÇÃO DE PROPERTIES
// ─────────────────────────────────────────────

log_msg('Iniciando migração de properties...');

$properties = $pg->query("
    SELECT
        id, title, slug, description,
        type, status, transaction_type,
        price, area,
        bedrooms, bathrooms, garages,
        address, neighborhood, city, state, zip_code,
        latitude, longitude,
        featured,
        created_at, updated_at
    FROM public.properties
    ORDER BY created_at
")->fetchAll();

log_msg(count($properties) . ' imóveis encontrados no PostgreSQL.');

$insertProperty = $mysql->prepare("
    INSERT INTO properties (
        id, title, slug, description,
        type, status, transaction_type,
        price, area,
        bedrooms, bathrooms, garages,
        address, neighborhood, city, state, zip_code,
        latitude, longitude,
        featured,
        created_at, updated_at
    ) VALUES (
        :id, :title, :slug, :description,
        :type, :status, :transaction_type,
        :price, :area,
        :bedrooms, :bathrooms, :garages,
        :address, :neighborhood, :city, :state, :zip_code,
        :latitude, :longitude,
        :featured,
        :created_at, :updated_at
    )
    ON DUPLICATE KEY UPDATE
        title            = VALUES(title),
        slug             = VALUES(slug),
        description      = VALUES(description),
        type             = VALUES(type),
        status           = VALUES(status),
        transaction_type = VALUES(transaction_type),
        price            = VALUES(price),
        area             = VALUES(area),
        bedrooms         = VALUES(bedrooms),
        bathrooms        = VALUES(bathrooms),
        garages          = VALUES(garages),
        address          = VALUES(address),
        neighborhood     = VALUES(neighborhood),
        city             = VALUES(city),
        state            = VALUES(state),
        zip_code         = VALUES(zip_code),
        latitude         = VALUES(latitude),
        longitude        = VALUES(longitude),
        featured         = VALUES(featured),
        updated_at       = VALUES(updated_at)
");

$okProperties   = 0;
$erroProperties = 0;

foreach ($properties as $p) {
    try {
        $insertProperty->execute([
            ':id'               => $p['id'],
            ':title'            => $p['title'],
            ':slug'             => $p['slug'] ?? null,
            ':description'      => $p['description'],
            ':type'             => $p['type']             ?? 'CASA',
            ':status'           => $p['status']           ?? 'DISPONIVEL',
            ':transaction_type' => $p['transaction_type'] ?? 'VENDA',
            ':price'            => $p['price'],
            ':area'             => $p['area']             ?? null,
            ':bedrooms'         => $p['bedrooms']         ?? null,
            ':bathrooms'        => $p['bathrooms']        ?? null,
            ':garages'          => $p['garages']          ?? null,
            ':address'          => $p['address'],
            ':neighborhood'     => $p['neighborhood']     ?? null,
            ':city'             => $p['city'],
            ':state'            => $p['state'],
            ':zip_code'         => $p['zip_code']         ?? null,
            ':latitude'         => normalizar_decimal($p['latitude']  ?? null),
            ':longitude'        => normalizar_decimal($p['longitude'] ?? null),
            ':featured'         => normalizar_booleano($p['featured'] ?? false),
            ':created_at'       => $p['created_at'],
            ':updated_at'       => $p['updated_at'],
        ]);
        $okProperties++;
        log_msg("Imóvel migrado: {$p['title']} ({$p['id']})", 'OK');
    } catch (PDOException $e) {
        $erroProperties++;
        log_msg("Erro ao migrar imóvel {$p['id']}: " . $e->getMessage(), 'ERRO');
    }
}

log_msg("Properties: {$okProperties} migrados, {$erroProperties} com erro.");

// ─────────────────────────────────────────────
// MIGRAÇÃO DE PROPERTY_IMAGES
// ─────────────────────────────────────────────

log_msg('Iniciando migração de property_images...');

$images = $pg->query("
    SELECT
        id, property_id,
        url,
        created_at
    FROM public.property_images
    ORDER BY property_id
")->fetchAll();

log_msg(count($images) . ' imagens encontradas no PostgreSQL.');

$insertImage = $mysql->prepare("
    INSERT INTO property_images (
        id, property_id,
        url,
        created_at
    ) VALUES (
        :id, :property_id,
        :url,
        :created_at
    )
    ON DUPLICATE KEY UPDATE
        url      = VALUES(url)
");

$okImages   = 0;
$erroImages = 0;
$skipImages = 0;

// IDs de properties que migraram com sucesso para não inserir imagens órfãs
$idsOk = $mysql->query("SELECT id FROM properties")->fetchAll(PDO::FETCH_COLUMN);
$idsOk = array_flip($idsOk);

foreach ($images as $img) {

    // Garante que o imóvel pai existe no MySQL
    if (!isset($idsOk[$img['property_id']])) {
        log_msg("Imagem {$img['id']} ignorada: imóvel {$img['property_id']} não existe no MySQL.", 'AVISO');
        $skipImages++;
        continue;
    }

    try {
        $insertImage->execute([
            ':id'          => $img['id'],
            ':property_id' => $img['property_id'],
            ':url'         => $img['url'],
            // ':path'        => $img['path']     ?? null,
            // ':is_cover'    => normalizar_booleano($img['is_cover'] ?? false),
            // ':order'       => $img['order']    ?? 0,
            ':created_at'  => $img['created_at'],
        ]);
        $okImages++;
        log_msg("Imagem migrada: {$img['id']} (imóvel: {$img['property_id']})", 'OK');
    } catch (PDOException $e) {
        $erroImages++;
        log_msg("Erro ao migrar imagem {$img['id']}: " . $e->getMessage(), 'ERRO');
    }
}

log_msg("Images: {$okImages} migradas, {$erroImages} com erro, {$skipImages} ignoradas.");

// ─────────────────────────────────────────────
// RESUMO FINAL
// ─────────────────────────────────────────────

echo "\n";
log_msg('─────────────────────────────────────', 'INFO');
log_msg("RESUMO FINAL", 'INFO');
log_msg("Properties → OK: {$okProperties} | Erro: {$erroProperties}", 'INFO');
log_msg("Images     → OK: {$okImages} | Erro: {$erroImages} | Ignoradas: {$skipImages}", 'INFO');
log_msg('─────────────────────────────────────', 'INFO');
log_msg('Migração concluída.', 'OK');
