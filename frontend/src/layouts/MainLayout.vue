<template>
	<q-layout view="hHh lpR fFf">
		<!-- Header -->
		<q-header elevated class="bg-primary text-white">
			<q-toolbar>
				<q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />

				<q-toolbar-title>
					<div class="row items-center">
						<q-icon name="business" size="sm" class="q-mr-sm" />
						<span>{{ appName }}</span>
					</div>
				</q-toolbar-title>

				<!-- Notificações -->
				<q-btn flat round dense icon="notifications">
					<q-badge color="red" floating>3</q-badge>
					<q-menu>
						<q-list style="min-width: 300px">
							<q-item clickable v-close-popup>
								<q-item-section avatar>
									<q-icon name="info" color="primary" />
								</q-item-section>
								<q-item-section>
									<q-item-label>Novo lead cadastrado</q-item-label>
									<q-item-label caption>Há 5 minutos</q-item-label>
								</q-item-section>
							</q-item>
							<q-separator />
							<q-item clickable v-close-popup>
								<q-item-section avatar>
									<q-icon name="home" color="positive" />
								</q-item-section>
								<q-item-section>
									<q-item-label>Novo imóvel disponível</q-item-label>
									<q-item-label caption>Há 1 hora</q-item-label>
								</q-item-section>
							</q-item>
						</q-list>
					</q-menu>
				</q-btn>

				<!-- Menu do usuário -->
				<q-btn flat round dense>
					<q-avatar size="32px">
						<img src="https://cdn.quasar.dev/img/avatar.png" />
					</q-avatar>
					<q-menu>
						<q-list style="min-width: 200px">
							<q-item>
								<q-item-section>
									<q-item-label class="text-weight-bold">{{ userName }}</q-item-label>
									<q-item-label caption>{{ userEmail }}</q-item-label>
								</q-item-section>
							</q-item>
							<q-separator />
							<q-item clickable v-close-popup @click="goToProfile">
								<q-item-section avatar>
									<q-icon name="person" />
								</q-item-section>
								<q-item-section>Perfil</q-item-section>
							</q-item>
							<q-item clickable v-close-popup @click="handleLogout">
								<q-item-section avatar>
									<q-icon name="logout" color="negative" />
								</q-item-section>
								<q-item-section>Sair</q-item-section>
							</q-item>
						</q-list>
					</q-menu>
				</q-btn>
			</q-toolbar>
		</q-header>

		<!-- Menu Lateral -->
		<q-drawer
			v-model="leftDrawerOpen"
			show-if-above
			bordered
			:width="260"
			:breakpoint="1024"
		>
			<q-scroll-area class="fit">
				<q-list padding>
					<!-- Dashboard -->
					<q-item
						clickable
						v-ripple
						:active="isActive('dashboard')"
						@click="navigateTo('dashboard')"
					>
						<q-item-section avatar>
							<q-icon name="dashboard" />
						</q-item-section>
						<q-item-section>
							<q-item-label>Dashboard</q-item-label>
						</q-item-section>
					</q-item>

					<q-separator class="q-my-sm" />

					<!-- Imóveis -->
					<q-item-label header class="text-weight-bold">Imóveis</q-item-label>

					<q-item
						clickable
						v-ripple
						:active="isActive('properties')"
						@click="navigateTo('properties')"
					>
						<q-item-section avatar>
							<q-icon name="home" />
						</q-item-section>
						<q-item-section>
							<q-item-label>Listagem</q-item-label>
						</q-item-section>
					</q-item>

					<q-item
						clickable
						v-ripple
						:active="isActive('property-create')"
						@click="navigateTo('property-create')"
					>
						<q-item-section avatar>
							<q-icon name="add_circle" />
						</q-item-section>
						<q-item-section>
							<q-item-label>Cadastrar</q-item-label>
						</q-item-section>
					</q-item>

					<q-separator class="q-my-sm" />

					<!-- CRM -->
					<q-item-label header class="text-weight-bold">CRM</q-item-label>

					<q-item
						clickable
						v-ripple
						:active="isActive('leads')"
						@click="navigateTo('leads')"
					>
						<q-item-section avatar>
							<q-icon name="trending_up" />
						</q-item-section>
						<q-item-section>
							<q-item-label>Leads</q-item-label>
						</q-item-section>
						<q-item-section side>
							<q-badge color="primary">{{ newLeadsCount }}</q-badge>
						</q-item-section>
					</q-item>

					<q-item
						clickable
						v-ripple
						:active="isActive('clients')"
						@click="navigateTo('clients')"
					>
						<q-item-section avatar>
							<q-icon name="people" />
						</q-item-section>
						<q-item-section>
							<q-item-label>Clientes</q-item-label>
						</q-item-section>
					</q-item>

					<q-separator class="q-my-sm" />

					<!-- Administração -->
					<q-item-label header class="text-weight-bold" v-if="isAdmin">
						Administração
					</q-item-label>

					<q-item
						v-if="isAdmin"
						clickable
						v-ripple
						:active="isActive('users')"
						@click="navigateTo('users')"
					>
						<q-item-section avatar>
							<q-icon name="admin_panel_settings" />
						</q-item-section>
						<q-item-section>
							<q-item-label>Usuários</q-item-label>
						</q-item-section>
					</q-item>
				</q-list>
			</q-scroll-area>

			<!-- Footer do menu -->
			<div class="absolute-bottom q-pa-md text-center">
				<q-separator class="q-mb-md" />
				<div class="text-caption text-grey-7">{{ appName }} v{{ appVersion }}</div>
			</div>
		</q-drawer>

		<!-- Conteúdo Principal -->
		<q-page-container>
			<router-view />
		</q-page-container>
	</q-layout>
</template>

<script setup lang="ts">
	import { ref, computed, onMounted } from "vue";
	import { useRouter, useRoute } from "vue-router";
	import { useQuasar } from "quasar";
	import { useAuthStore } from "src/stores/auth";
	import { useLeadStore } from "src/stores/lead"; // Certifique-se de que este store existe e está correto

	const $q = useQuasar();
	const router = useRouter();
	const route = useRoute();
	const authStore = useAuthStore();
	const leadStore = useLeadStore(); // Assumindo que useLeadStore está implementado

	// Estado do menu lateral
	const leftDrawerOpen = ref<boolean>(false);

	// Dados do app
	const appName: string = import.meta.env.VITE_APP_NAME || "Imobiliária Pro";
	const appVersion: string = import.meta.env.VITE_APP_VERSION || "1.0.0";

	// Dados do usuário
	const userName = computed<string>(() => authStore.userName);
	const userEmail = computed<string>(() => authStore.userEmail);
	const isAdmin = computed<boolean>(() => authStore.isAdmin);

	// Contadores
	const newLeadsCount = computed<number>(() => {
		// Verifique se leadStore.leads está disponível e é um array
		return leadStore.leads?.filter((lead) => lead.status === "NOVO").length || 0;
	});

	// Funções
	const toggleLeftDrawer = (): void => {
		leftDrawerOpen.value = !leftDrawerOpen.value;
	};

	const isActive = (routeName: string): boolean => {
		return route.name === routeName;
	};

	const navigateTo = (routeName: string): void => {
		router.push({ name: routeName });
	};

	const goToProfile = (): void => {
		router.push({ name: "profile" });
	};

	const handleLogout = (): void => {
		$q.dialog({
			title: "Confirmar saída",
			message: "Deseja realmente sair do sistema?",
			cancel: {
				label: "Cancelar",
				color: "grey",
				flat: true,
			},
			ok: {
				label: "Sair",
				color: "negative",
			},
			persistent: true,
		}).onOk(async () => {
			// Adicionado async aqui
			await authStore.logout(); // Aguardar o logout
			// O router.push já está dentro do authStore.logout, então pode ser removido daqui
			$q.notify({
				type: "positive",
				message: "Logout realizado com sucesso",
				position: "top",
			});
		});
	};

	// Carregar dados iniciais
	onMounted(async () => {
		// Tenta buscar os dados do usuário logado
		await authStore.getMe();
		try {
			// Apenas tenta buscar leads se o usuário estiver autenticado
			if (authStore.token) {
				await leadStore.fetchLeads({ limit: 100 });
			}
		} catch (error: unknown) {
			// Usar unknown para erro de catch
			console.error("Erro ao carregar dados de leads:", error);
			// Não precisa de notify aqui, pois o interceptor do axios ou o próprio store já deve lidar com erros de auth
		}
	});
</script>

<style lang="scss" scoped>
	.q-item {
		border-radius: 8px;
		margin: 4px 8px;

		&.q-router-link--active {
			background-color: rgba(var(--q-primary-rgb), 0.1);
			color: var(--q-primary);
			font-weight: 600;

			.q-icon {
				color: var(--q-primary);
			}
		}

		&:hover {
			background-color: rgba(0, 0, 0, 0.05);
		}
	}

	.q-drawer {
		.q-item-label--header {
			padding-left: 16px;
			font-size: 12px;
			text-transform: uppercase;
			letter-spacing: 0.5px;
		}
	}
</style>
