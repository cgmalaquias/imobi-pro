<!-- frontend/src/pages/LoginPage.vue -->
<template>
	<div class="login-container">
		<q-card class="login-card">
			<q-card-section class="text-center q-pb-none">
				<div class="text-h5 text-weight-bold q-mb-md">
					<q-icon name="home" size="40px" color="primary" />
					<div>Imobiliária Pro</div>
				</div>
				<p class="text-subtitle2 text-grey-7">Bem-vindo de volta!</p>
			</q-card-section>
			<q-card-section>
				<q-form @submit="handleLogin" class="q-gutter-md">
					<q-input
						v-model="form.email"
						type="email"
						label="Email"
						outlined
						dense
						:rules="[
							(val) => !!val || 'Email é obrigatório',
							(val) => isValidEmail(val) || 'Email inválido',
						]"
						prefix-icon="email"
					/>
					<q-input
						v-model="form.password"
						:type="showPassword ? 'text' : 'password'"
						label="Senha"
						outlined
						dense
						:rules="[(val) => !!val || 'Senha é obrigatória']"
						prefix-icon="lock"
						:suffix-icon="showPassword ? 'visibility_off' : 'visibility'"
						@click:suffix="showPassword = !showPassword"
					/>
					<div class="flex justify-between items-center">
						<q-checkbox v-model="form.rememberMe" label="Lembrar-me" />
						<q-btn flat label="Esqueci a senha" to="/forgot-password" />
					</div>
					<q-btn
						type="submit"
						label="Entrar"
						color="primary"
						size="lg"
						class="full-width"
						:loading="authStore.loading"
					/>
				</q-form>
			</q-card-section>
			<q-card-section class="text-center">
				<p class="text-grey-7">
					Não tem conta?
					<q-btn flat label="Registre-se" to="/register" />
				</p>
			</q-card-section>
		</q-card>
	</div>
</template>

<script setup lang="ts">
	import { ref, reactive } from "vue";
	import { useRouter } from "vue-router";
	import { useAuthStore } from "@stores/auth";
	import { Notify } from "quasar"; // Importar Notify para mensagens

	const router = useRouter();
	const authStore = useAuthStore();

	const showPassword = ref(false);
	const form = reactive({
		email: "",
		password: "",
		rememberMe: false,
	});

	const isValidEmail = (email: string): boolean => {
		const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		return re.test(email);
	};

	const handleLogin = async () => {
		console.log("DEBUG FRONTEND: Tentando login com:", {
			email: form.email,
			password: form.password,
		});
		const success = await authStore.login(form.email, form.password);
		if (success) {
			await router.push({ name: "dashboard" });
		}
	};
</script>

<style scoped lang="scss">
	.login-container {
		display: flex;
		align-items: center;
		justify-content: center;
		min-height: 100vh;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	}
	.login-card {
		width: 100%;
		max-width: 400px;
		border-radius: 12px;
		box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
	}
</style>
