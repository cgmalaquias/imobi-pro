<!-- frontend/src/App.vue -->
<template>
	<router-view />
</template>

<script setup lang="ts">
	import { onMounted } from "vue";
	import { useAuthStore } from "src/stores/auth";
	import { useRouter } from "vue-router";

	const authStore = useAuthStore();
	const router = useRouter();

	onMounted(async () => {
		// Se houver um token, tente buscar os dados do usuário para validar a sessão
		if (authStore.token) {
			const user = await authStore.getMe();
			if (!user) {
				// Se getMe falhar (token inválido/expirado), ele já redireciona para /login
				// ou limpa os dados. Podemos adicionar um redirecionamento explícito aqui se necessário.
				// router.push('/login');
			}
		} else {
			// Se não houver token, e a rota atual requer autenticação, redirecione para login
			if (
				router.currentRoute.value.meta.requiresAuth &&
				router.currentRoute.value.name !== "login"
			) {
				await router.push("/login");
			}
		}
	});
</script>
