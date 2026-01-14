<template>
	<div class="register-container">
		<q-card class="register-card">
			<q-card-section class="text-center q-pb-none">
				<div class="text-h5 text-weight-bold q-mb-md">
					<q-icon name="home" size="40px" color="primary" />
					<div>Criar Conta</div>
				</div>
				<p class="text-subtitle2 text-grey-7">Junte-se a nós!</p>
			</q-card-section>

			<q-card-section>
				<q-form @submit="handleRegister" class="q-gutter-md">
					<q-input
						v-model="name"
						label="Nome completo"
						outlined
						dense
						:rules="[(val) => !!val || 'Campo obrigatório']"
					>
						<template v-slot:prepend>
							<q-icon name="person" />
						</template>
					</q-input>

					<q-input
						v-model="email"
						label="E-mail"
						type="email"
						outlined
						dense
						:rules="[
							(val) => !!val || 'Campo obrigatório',
							(val) => /.+@.+\..+/.test(val) || 'E-mail inválido',
						]"
					>
						<template v-slot:prepend>
							<q-icon name="email" />
						</template>
					</q-input>

					<q-input
						v-model="phone"
						label="Telefone (opcional)"
						outlined
						dense
						mask="(##) #####-####"
					>
						<template v-slot:prepend>
							<q-icon name="phone" />
						</template>
					</q-input>

					<q-input
						v-model="password"
						label="Senha"
						:type="showPassword ? 'text' : 'password'"
						outlined
						dense
						:rules="[
							(val) => !!val || 'Campo obrigatório',
							(val) => val.length >= 6 || 'Mínimo 6 caracteres',
						]"
					>
						<template v-slot:prepend>
							<q-icon name="lock" />
						</template>
						<template v-slot:append>
							<q-icon
								:name="showPassword ? 'visibility' : 'visibility_off'"
								class="cursor-pointer"
								@click="showPassword = !showPassword"
							/>
						</template>
					</q-input>

					<div class="q-mt-md">
						<q-btn
							label="Registrar"
							type="submit"
							color="primary"
							class="full-width"
							:loading="loading"
							:disable="loading"
						/>
					</div>

					<div class="q-mt-sm">
						<q-btn
							label="Já tenho conta"
							outline
							color="primary"
							class="full-width"
							@click="router.push('/login')"
						/>
					</div>
				</q-form>
			</q-card-section>

			<q-card-section class="text-center">
				<p class="text-grey-7">
					Já tem conta?
					<q-btn flat label="Faça login" to="/login" />
				</p>
			</q-card-section>
		</q-card>
	</div>
</template>

<script setup lang="ts">
	import { ref } from "vue";
	import { useRouter } from "vue-router";
	import { useQuasar } from "quasar";
	import { useAuthStore } from "src/stores/auth";

	const router = useRouter();
	const $q = useQuasar();
	const authStore = useAuthStore();

	// Estados individuais ao invés de reactive
	const name = ref("");
	const email = ref("");
	const phone = ref("");
	const password = ref("");
	const showPassword = ref(false);
	const loading = ref(false);

	const handleRegister = async (): Promise<void> => {
		loading.value = true;

		console.log("📋 Valores capturados do formulário:");
		console.log("Nome:", name.value);
		console.log("Email:", email.value);
		console.log("Phone:", phone.value);
		console.log("Password:", password.value ? "***" : "vazio");

		try {
			await authStore.register({
				name: name.value,
				email: email.value,
				phone: phone.value || undefined,
				password: password.value,
			});

			$q.notify({
				type: "positive",
				message: "Conta criada com sucesso!",
				position: "top",
			});

			await router.push("/");
		} catch (error) {
			console.error("❌ Erro no registro:", error);

			$q.notify({
				type: "negative",
				message: authStore.error || "Erro ao registrar",
				position: "top",
			});
		} finally {
			loading.value = false;
		}
	};
</script>
<style scoped lang="scss">
	.register-container {
		display: flex;
		align-items: center;
		justify-content: center;
		min-height: 100vh;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		padding: 20px;
	}

	.register-card {
		width: 100%;
		max-width: 450px;
		border-radius: 12px;
		box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
	}
</style>
