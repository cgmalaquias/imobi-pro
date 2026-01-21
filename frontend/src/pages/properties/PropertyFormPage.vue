<template>
	<q-page class="q-pa-md">
		<div class="row items-center q-mb-md">
			<q-btn icon="arrow_back" flat round dense @click="router.back()" class="q-mr-sm" />
			<div class="text-h5">{{ isEditing ? "Editar Imóvel" : "Novo Imóvel" }}</div>
		</div>

		<q-card flat bordered class="q-pa-md">
			<q-form @submit="onSubmit">
				<div class="row q-col-gutter-md">
					<!-- Título e Descrição -->
					<div class="col-12">
						<q-input
							v-model="form.title"
							label="Título do Imóvel *"
							outlined
							dense
							:rules="[(val) => !!val || 'Título é obrigatório']"
						/>
					</div>
					<div class="col-12">
						<q-input
							v-model="form.description"
							label="Descrição Detalhada"
							outlined
							dense
							type="textarea"
							rows="4"
						/>
					</div>

					<!-- Tipo e Transação -->
					<div class="col-12 col-md-4">
						<q-select
							v-model="form.type"
							:options="propertyTypes"
							label="Tipo de Imóvel *"
							outlined
							dense
							emit-value
							map-options
							:rules="[(val) => !!val || 'Tipo é obrigatório']"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-select
							v-model="form.transactionType"
							:options="transactionTypes"
							label="Tipo de Transação *"
							outlined
							dense
							emit-value
							map-options
							:rules="[(val) => !!val || 'Tipo de transação é obrigatório']"
						/>
					</div>

					<!-- Preços -->
					<div class="col-12 col-md-6">
						<q-input
							v-model.number="form.priceSale"
							label="Preço de Venda"
							outlined
							dense
							type="number"
							prefix="R$"
							step="0.01"
							:rules="[
								(val) =>
									(form.transactionType === 'VENDA' || form.transactionType === 'AMBOS'
										? !!val && val > 0
										: true) || 'Preço de venda é obrigatório para venda',
							]"
						/>
					</div>
					<div class="col-12 col-md-6">
						<q-input
							v-model.number="form.priceRent"
							label="Preço de Aluguel"
							outlined
							dense
							type="number"
							prefix="R$"
							step="0.01"
							:rules="[
								(val) =>
									(form.transactionType === 'ALUGUEL' || form.transactionType === 'AMBOS'
										? !!val && val > 0
										: true) || 'Preço de aluguel é obrigatório para aluguel',
							]"
						/>
					</div>

					<!-- Endereço -->
					<div class="col-12 col-md-6">
						<q-input
							v-model="form.address"
							label="Endereço *"
							outlined
							dense
							:rules="[(val) => !!val || 'Endereço é obrigatório']"
						/>
					</div>
					<div class="col-12 col-md-6">
						<q-input
							v-model="form.neighborhood"
							label="Bairro *"
							outlined
							dense
							:rules="[(val) => !!val || 'Bairro é obrigatório']"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-input
							v-model="form.city"
							label="Cidade *"
							outlined
							dense
							:rules="[(val) => !!val || 'Cidade é obrigatória']"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-input
							v-model="form.state"
							label="Estado (UF) *"
							outlined
							dense
							maxlength="2"
							:rules="[(val) => !!val || 'Estado é obrigatório']"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-input
							v-model="form.zipCode"
							label="CEP"
							outlined
							dense
							mask="#####-###"
							unmasked-value
						/>
					</div>

					<!-- Áreas e Quartos/Banheiros/Garagem -->
					<div class="col-12 col-md-6">
						<q-input
							v-model.number="form.areaTotal"
							label="Área Total (m²)"
							outlined
							dense
							type="number"
							step="0.01"
							suffix="m²"
							:rules="[
								(val) =>
									val === null ||
									val === undefined ||
									val >= 0 ||
									'Área deve ser positiva',
							]"
						/>
					</div>
					<div class="col-12 col-md-6">
						<q-input
							v-model.number="form.areaBuilt"
							label="Área Construída (m²)"
							outlined
							dense
							type="number"
							step="0.01"
							suffix="m²"
							:rules="[
								(val) =>
									val === null ||
									val === undefined ||
									val >= 0 ||
									'Área deve ser positiva',
							]"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-input
							v-model.number="form.bedrooms"
							label="Quartos"
							outlined
							dense
							type="number"
							:rules="[
								(val) =>
									val === null ||
									val === undefined ||
									val >= 0 ||
									'Número deve ser positivo',
							]"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-input
							v-model.number="form.bathrooms"
							label="Banheiros"
							outlined
							dense
							type="number"
							:rules="[
								(val) =>
									val === null ||
									val === undefined ||
									val >= 0 ||
									'Número deve ser positivo',
							]"
						/>
					</div>
					<div class="col-12 col-md-4">
						<q-input
							v-model.number="form.garage"
							label="Vagas de Garagem"
							outlined
							dense
							type="number"
							:rules="[
								(val) =>
									val === null ||
									val === undefined ||
									val >= 0 ||
									'Número deve ser positivo',
							]"
						/>
					</div>

					<!-- Status e Destaque -->
					<div class="col-12 col-md-6">
						<q-select
							v-model="form.status"
							:options="propertyStatuses"
							label="Status do Imóvel"
							outlined
							dense
							emit-value
							map-options
							:rules="[(val) => !!val || 'Status é obrigatório']"
						/>
					</div>
					<div class="col-12 col-md-6">
						<q-toggle v-model="form.featured" label="Imóvel em Destaque" />
					</div>

					<!-- Upload de Imagens -->
					<div class="col-12">
						<q-card flat bordered class="q-pa-md">
							<q-card-section>
								<div class="text-h6 q-mb-sm">Imagens do Imóvel</div>
								<q-file
									v-model="newImages"
									label="Adicionar Imagens"
									outlined
									dense
									multiple
									accept=".jpg, .jpeg, .png, .gif"
									counter
									max-files="5"
									@update:model-value="handleNewImageSelection"
								>
									<template v-slot:prepend>
										<q-icon name="attach_file" />
									</template>
									<template v-slot:append>
										<q-btn
											v-if="newImages.length > 0 && isEditing"
											icon="upload"
											round
											dense
											flat
											@click="uploadSelectedImages"
											color="primary"
											label="Upload"
										/>
									</template>
								</q-file>
								<div class="q-mt-md row q-col-gutter-sm">
									<div
										v-for="(image, index) in form.images"
										:key="image.id"
										class="col-6 col-sm-4 col-md-3 relative-position"
									>
										<q-img :src="image.url" ratio="1" class="rounded-borders">
											<q-btn
												round
												dense
												flat
												icon="delete"
												color="negative"
												size="sm"
												class="absolute-top-right q-ma-xs"
												@click="confirmDeleteImage(image.id)"
											/>
											<q-badge color="dark" class="absolute-bottom-left q-ma-xs">{{
												index + 1
											}}</q-badge>
										</q-img>
									</div>
									<div v-if="!form.images || form.images.length === 0" class="col-12">
										<q-item-label caption>Nenhuma imagem adicionada ainda.</q-item-label>
									</div>
								</div>
							</q-card-section>
						</q-card>
					</div>

					<!-- Botões de Ação -->
					<div class="col-12 q-mt-md">
						<q-btn
							label="Salvar Imóvel"
							type="submit"
							color="primary"
							:loading="propertyStore.loading"
							class="q-mr-sm"
						/>
						<q-btn
							label="Cancelar"
							type="button"
							color="grey"
							flat
							@click="router.back()"
						/>
					</div>
				</div>
			</q-form>
		</q-card>
	</q-page>
</template>

<script setup lang="ts">
	import { ref, computed, onMounted, watch } from "vue";
	import { useRoute, useRouter } from "vue-router";
	import { useQuasar, Notify } from "quasar";
	import type {
		Property,
		PropertyType,
		PropertyStatus,
		TransactionType,
	} from "src/stores/property";
	import { usePropertyStore, PropertyImage } from "src/stores/property";
	import { storeToRefs } from "pinia";

	const $q = useQuasar();
	const route = useRoute();
	const router = useRouter();
	const propertyStore = usePropertyStore();
	const { currentProperty } = storeToRefs(propertyStore);

	const isEditing = computed<boolean>(() => !!route.params.id);
	const propertyId = computed<string>(() => route.params.id as string);

	const form = ref<Partial<Property>>({
		title: "",
		description: "",
		type: "CASA",
		transactionType: "VENDA",
		status: "DISPONIVEL",
		priceSale: undefined,
		priceRent: undefined,
		address: "",
		neighborhood: "",
		city: "",
		state: "",
		zipCode: "",
		areaTotal: undefined,
		areaBuilt: undefined,
		bedrooms: undefined,
		bathrooms: undefined,
		garage: undefined,
		featured: false,
		images: [],
	});

	const newImages = ref<File[]>([]);

	const propertyTypes: { label: string; value: PropertyType }[] = [
		{ label: "Casa", value: "CASA" },
		{ label: "Apartamento", value: "APARTAMENTO" },
		{ label: "Terreno", value: "TERRENO" },
		{ label: "Comercial", value: "COMERCIAL" },
		{ label: "Rural", value: "RURAL" },
	];

	const transactionTypes: { label: string; value: TransactionType }[] = [
		{ label: "Venda", value: "VENDA" },
		{ label: "Aluguel", value: "ALUGUEL" },
		{ label: "Ambos", value: "AMBOS" },
	];

	const propertyStatuses: { label: string; value: PropertyStatus }[] = [
		{ label: "Disponível", value: "DISPONIVEL" },
		{ label: "Reservado", value: "RESERVADO" },
		{ label: "Vendido", value: "VENDIDO" },
		{ label: "Alugado", value: "ALUGADO" },
		{ label: "Inativo", value: "INATIVO" },
	];

	const loadPropertyForEditing = async (id: string): Promise<void> => {
		try {
			const property = await propertyStore.fetchPropertyById(id);
			if (property) {
				form.value = {
					...property,
					priceSale: property.priceSale
						? parseFloat(property.priceSale.toString())
						: undefined,
					priceRent: property.priceRent
						? parseFloat(property.priceRent.toString())
						: undefined,
					areaTotal: property.areaTotal
						? parseFloat(property.areaTotal.toString())
						: undefined,
					areaBuilt: property.areaBuilt
						? parseFloat(property.areaBuilt.toString())
						: undefined,
					bedrooms: property.bedrooms
						? parseInt(property.bedrooms.toString())
						: undefined,
					bathrooms: property.bathrooms
						? parseInt(property.bathrooms.toString())
						: undefined,
					garage: property.garage ? parseInt(property.garage.toString()) : undefined,
					featured: property.featured,
					images: property.images || [],
				};
			}
		} catch (error) {
			console.error("Erro ao carregar imóvel para edição:", error);
			$q.notify({
				type: "negative",
				message: "Erro ao carregar dados do imóvel.",
				position: "top-right",
			});
			router.push({ name: "properties" });
		}
	};

	const onSubmit = async (): Promise<void> => {
		try {
			if (isEditing.value) {
				await propertyStore.updateProperty(propertyId.value, form.value);
				$q.notify({
					type: "positive",
					message: "Imóvel atualizado com sucesso!",
					position: "top-right",
				});
				await router.push({ name: "properties" }); // Redireciona após a edição
			} else {
				// Para criação, precisamos enviar FormData se houver imagens
				const formData = new FormData();
				for (const key in form.value) {
					const value = (form.value as any)[key]; // Usar any temporariamente para acessar a chave
					if (value !== undefined && value !== null) {
						if (key === "images") {
							// Imagens existentes não são enviadas no create
						} else if (typeof value === "boolean") {
							formData.append(key, value ? "true" : "false");
						} else if (typeof value === "number") {
							formData.append(key, value.toString());
						} else {
							formData.append(key, value);
						}
					}
				}
				newImages.value.forEach((file) => {
					formData.append("images", file);
				});

        const newProperty = await propertyStore.createProperty(formData); // <-- Envia FormData
        if (!newProperty) {
          $q.notify({
            type: "negative",
            message: "Falha ao criar o imóvel.",
            position: "top-right",
          });
          throw new Error("Falha ao criar o imóvel.");
        }
				$q.notify({
					type: "positive",
					message: "Imóvel criado com sucesso!",
					position: "top-right",
        });

				// ✅ REDIRECIONAR PARA A LISTA DE IMÓVEIS APÓS O CADASTRO
				await router.push({ name: "properties" });
				// router.replace({ name: "property-edit", params: { id: newProperty.id } }); // Redireciona para a página de edição do novo imóvel
			}
		} catch (error) {
			console.error("Erro ao salvar imóvel:", error);
			$q.notify({
				type: "negative",
				message: propertyStore.error || "Falha ao salvar imóvel.",
				position: "top-right",
			});
		}
	};

	const handleNewImageSelection = (files: File[] | null) => {
		newImages.value = files || [];
	};

	const uploadSelectedImages = async () => {
		if (newImages.value.length === 0) {
			$q.notify({
				type: "warning",
				message: "Nenhuma imagem selecionada para upload.",
				position: "top-right",
			});
			return;
		}
		if (!propertyId.value) {
			$q.notify({
				type: "negative",
				message: "Imóvel não salvo. Salve o imóvel antes de adicionar imagens.",
				position: "top-right",
			});
			return;
		}

		try {
			await propertyStore.uploadImages(propertyId.value, newImages.value);
			$q.notify({
				type: "positive",
				message: `${newImages.value.length} imagem(ns) enviada(s) com sucesso!`,
				position: "top-right",
			});
			newImages.value = []; // Limpa as imagens selecionadas
		} catch (error) {
			console.error("Erro ao fazer upload:", error);
			$q.notify({
				type: "negative",
				message: propertyStore.error || "Falha ao enviar imagens.",
				position: "top-right",
			});
		}
	};

	const confirmDeleteImage = (imageId: string) => {
		$q.dialog({
			title: "Confirmar Exclusão",
			message: "Tem certeza que deseja excluir esta imagem?",
			cancel: true,
			persistent: true,
		}).onOk(async () => {
			try {
				await propertyStore.deleteImage(imageId);
				$q.notify({
					type: "positive",
					message: "Imagem excluída com sucesso!",
					position: "top-right",
				});
			} catch (error) {
				console.error("Erro ao excluir imagem:", error);
				$q.notify({
					type: "negative",
					message: propertyStore.error || "Falha ao excluir imagem.",
					position: "top-right",
				});
			}
		});
	};

	onMounted(async () => {
		if (isEditing.value && propertyId.value) {
			await loadPropertyForEditing(propertyId.value);
		} else {
			propertyStore.clearCurrentProperty(); // Limpa o imóvel atual ao criar um novo
		}
	});

	// Observar mudanças no currentProperty para manter o formulário atualizado
	watch(currentProperty, (newVal) => {
		if (newVal && isEditing.value) {
			form.value = { ...newVal };
			// Conversão de Decimal para number para campos de preço e área
			if (typeof form.value.priceSale === "string") {
				form.value.priceSale = parseFloat(form.value.priceSale);
			}
			if (typeof form.value.priceRent === "string") {
				form.value.priceRent = parseFloat(form.value.priceRent);
			}
			if (typeof form.value.areaTotal === "string") {
				form.value.areaTotal = parseFloat(form.value.areaTotal);
			}
			if (typeof form.value.areaBuilt === "string") {
				form.value.areaBuilt = parseFloat(form.value.areaBuilt);
			}
		}
	});
</script>

<style scoped>
	/* Estilos específicos do componente, se necessário */
</style>
