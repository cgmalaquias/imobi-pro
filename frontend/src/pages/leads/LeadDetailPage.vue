<template>
	<div class="lead-detail">
		<header>
			<h1>Lead {{ lead?.id ? `#${lead.id}` : "" }}</h1>
			<div v-if="loading">Carregando...</div>
		</header>

		<main v-if="!loading && !error">
			<section class="lead-info">
				<p><strong>Nome:</strong> {{ lead.name || "-" }}</p>
				<p><strong>Email:</strong> {{ lead.email || "-" }}</p>
				<p><strong>Telefone:</strong> {{ lead.phone || "-" }}</p>
				<p><strong>Status:</strong> {{ lead.status || "-" }}</p>
				<p><strong>Origem:</strong> {{ lead.source || "-" }}</p>
				<p><strong>Notas:</strong> {{ lead.notes || "Nenhuma" }}</p>
			</section>

			<section class="actions">
				<button @click="goToEdit">Editar</button>
				<button @click="toggleFavorite">
					{{ lead.favorite ? "Remover favorito" : "Marcar favorito" }}
				</button>
				<button @click="confirmDelete" class="danger">Excluir</button>
			</section>
		</main>

		<div v-if="error" class="error">{{ error }}</div>
	</div>
</template>

<script setup>
	import { ref, onMounted } from "vue";
	import { useRoute, useRouter } from "vue-router";
	import axios from "axios"; // ajuste para o cliente HTTP do seu projeto

	const route = useRoute();
	const router = useRouter();
	const id = route.params.id;

	const lead = ref({});
	const loading = ref(false);
	const error = ref("");

	async function fetchLead() {
		loading.value = true;
		error.value = "";
		try {
			const { data } = await axios.get(`/api/leads/${id}`);
			lead.value = data;
		} catch (err) {
			error.value =
				err?.response?.data?.message || err.message || "Erro ao carregar lead.";
		} finally {
			loading.value = false;
		}
	}

	function goToEdit() {
		router.push({ name: "LeadEdit", params: { id } });
	}

	async function toggleFavorite() {
		try {
			const { data } = await axios.patch(`/api/leads/${id}`, {
				favorite: !lead.value.favorite,
			});
			lead.value = data;
		} catch {
			alert("Erro ao atualizar favorito.");
		}
	}

	async function confirmDelete() {
		if (!confirm("Confirmar exclusão deste lead?")) return;
		try {
			await axios.delete(`/api/leads/${id}`);
			router.push({ name: "LeadsList" });
		} catch {
			alert("Erro ao excluir lead.");
		}
	}

	onMounted(fetchLead);
</script>

<style scoped>
	.lead-detail {
		padding: 1rem;
	}
	.actions {
		margin-top: 1rem;
		display: flex;
		gap: 0.5rem;
	}
	.danger {
		background: #f66;
		color: white;
	}
	.error {
		color: #c00;
		margin-top: 1rem;
	}
</style>
