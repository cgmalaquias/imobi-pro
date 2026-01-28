<template>
	<q-page padding>
		<div class="q-pa-md">
			<div class="row justify-center">
				<div class="col-12 col-md-8 col-lg-6">
					<q-card>
						<q-card-section class="bg-primary text-white">
							<div class="text-h5">Meu Perfil</div>
							<div class="text-subtitle2">Gerencie suas informações pessoais</div>
						</q-card-section>

						<q-separator />

						<q-card-section>
							<div class="row q-col-gutter-md">
								<!-- Avatar -->
								<div class="col-12 text-center">
									<q-avatar size="120px">
										<img src="https://cdn.quasar.dev/img/avatar.png" />
									</q-avatar>
									<div class="q-mt-md">
										<q-btn
											label="Alterar foto"
											color="primary"
											outline
											size="sm"
											icon="photo_camera"
										/>
									</div>
								</div>

								<!-- Informações -->
								<div class="col-12">
									<q-input
										v-model="form.name"
										label="Nome completo"
										outlined
										:readonly="!editing"
									>
										<template v-slot:prepend>
											<q-icon name="person" />
										</template>
									</q-input>
								</div>

								<div class="col-12">
									<q-input
										v-model="form.email"
										label="E-mail"
										type="email"
										outlined
										readonly
									>
										<template v-slot:prepend>
											<q-icon name="email" />
										</template>
									</q-input>
								</div>

								<div class="col-12">
									<q-input
										v-model="form.phone"
										label="Telefone"
										outlined
										mask="(##) #####-####"
										:readonly="!editing"
									>
										<template v-slot:prepend>
											<q-icon name="phone" />
										</template>
									</q-input>
								</div>

								<div class="col-12">
									<q-input v-model="form.role" label="Cargo" outlined readonly>
										<template v-slot:prepend>
											<q-icon name="badge" />
										</template>
									</q-input>
								</div>
							</div>
						</q-card-section>

						<q-separator />

						<q-card-actions align="right" class="q-pa-md">
							<q-btn
								v-if="!editing"
								label="Editar"
								color="primary"
								icon="edit"
								@click="startEditing"
							/>
							<template v-else>
								<q-btn label="Cancelar" color="grey" flat @click="cancelEditing" />
								<q-btn
									label="Salvar"
									color="primary"
									icon="save"
									@click="saveProfile"
									:loading="loading"
								/>
							</template>
						</q-card-actions>
					</q-card>

					<!-- Alterar senha -->
					<q-card class="q-mt-md">
						<q-card-section class="bg-secondary text-white">
							<div class="text-h6">Alterar Senha</div>
						</q-card-section>

						<q-card-section>
							<div class="row q-col-gutter-md">
								<div class="col-12">
									<q-input
										v-model="passwordForm.currentPassword"
										label="Senha atual"
										type="password"
										outlined
									>
										<template v-slot:prepend>
											<q-icon name="lock" />
										</template>
									</q-input>
								</div>

								<div class="col-12">
									<q-input
										v-model="passwordForm.newPassword"
										label="Nova senha"
										type="password"
										outlined
									>
										<template v-slot:prepend>
											<q-icon name="lock_open" />
										</template>
									</q-input>
								</div>

								<div class="col-12">
									<q-input
										v-model="passwordForm.confirmPassword"
										label="Confirmar nova senha"
										type="password"
										outlined
									>
										<template v-slot:prepend>
											<q-icon name="lock_open" />
										</template>
									</q-input>
								</div>
							</div>
						</q-card-section>

						<q-card-actions align="right" class="q-pa-md">
							<q-btn
								label="Alterar Senha"
								color="secondary"
								icon="vpn_key"
								@click="changePassword"
								:loading="loadingPassword"
							/>
						</q-card-actions>
					</q-card>
				</div>
			</div>
		</div>
	</q-page>
</template>

<script setup lang="ts">
	import { ref, reactive, onMounted } from "vue";
	import { useQuasar } from "quasar";
	import { useAuthStore } from "src/stores/auth";

	const $q = useQuasar();
	const authStore = useAuthStore();

	const editing = ref(false);
	const loading = ref(false);
	const loadingPassword = ref(false);

	const form = reactive({
		name: "",
		email: "",
		phone: "",
		role: "",
	});

	const originalForm = reactive({
		name: "",
		phone: "",
	});

	const passwordForm = reactive({
		currentPassword: "",
		newPassword: "",
		confirmPassword: "",
	});

	const startEditing = (): void => {
		editing.value = true;
		originalForm.name = form.name;
		originalForm.phone = form.phone;
	};

	const cancelEditing = (): void => {
		editing.value = false;
		form.name = originalForm.name;
		form.phone = originalForm.phone;
	};

	const saveProfile = async (): Promise<void> => {
		loading.value = true;

		try {
			// Aqui você faria a chamada para atualizar o perfil
			await new Promise((resolve) => setTimeout(resolve, 1000));

			$q.notify({
				type: "positive",
				message: "Perfil atualizado com sucesso",
				position: "top",
			});

			editing.value = false;
		} catch (error) {
			$q.notify({
				type: "negative",
				message: "Erro ao atualizar perfil",
				position: "top",
			});
		} finally {
			loading.value = false;
		}
	};

	const changePassword = async (): Promise<void> => {
		if (passwordForm.newPassword !== passwordForm.confirmPassword) {
			$q.notify({
				type: "negative",
				message: "As senhas não conferem",
				position: "top",
			});
			return;
		}

		loadingPassword.value = true;

		try {
			// Aqui você faria a chamada para alterar a senha
			await new Promise((resolve) => setTimeout(resolve, 1000));

			$q.notify({
				type: "positive",
				message: "Senha alterada com sucesso",
				position: "top",
			});

			passwordForm.currentPassword = "";
			passwordForm.newPassword = "";
			passwordForm.confirmPassword = "";
		} catch (error) {
			$q.notify({
				type: "negative",
				message: "Erro ao alterar senha",
				position: "top",
			});
		} finally {
			loadingPassword.value = false;
		}
	};

	onMounted(() => {
		if (authStore.user) {
			form.name = authStore.user.name;
			form.email = authStore.user.email;
			form.phone = authStore.user.phone || "";
			form.role = authStore.user.role;
		}
	});
</script>
