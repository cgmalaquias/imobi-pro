<template>
	<q-page class="q-pa-md">
		<div class="row items-center justify-between q-mb-md">
			<div class="text-h5">Imóveis</div>

			<q-btn
				color="primary"
				icon="add"
				label="Novo Imóvel"
				@click="router.push({ name: 'property-create' })"
			/>
		</div>

		<!-- Filtros -->
		<q-card flat bordered class="q-pa-md q-mb-md">
			<div class="row q-col-gutter-md">
				<div class="col-12 col-md-3">
					<q-input
						v-model="filters.search"
						outlined
						dense
						label="Buscar por título, bairro ou cidade"
						debounce="400"
						@update:model-value="loadProperties"
						clearable
					>
						<template #prepend>
							<q-icon name="search" />
						</template>
					</q-input>
				</div>

				<div class="col-12 col-md-2">
					<q-select
						v-model="filters.type"
						:options="propertyTypes"
						label="Tipo"
						outlined
						dense
						clearable
						@update:model-value="loadProperties"
					/>
				</div>

				<div class="col-12 col-md-2">
					<q-select
						v-model="filters.status"
						:options="propertyStatus"
						label="Status"
						outlined
						dense
						clearable
						@update:model-value="loadProperties"
					/>
				</div>

				<div class="col-12 col-md-2">
					<q-input
						v-model="filters.city"
						label="Cidade"
						outlined
						dense
						clearable
						@update:model-value="loadProperties"
					/>
				</div>
			</div>
		</q-card>

		<!-- Lista de imóveis -->
		<q-card>
			<q-table
				:rows="propertyStore.properties"
				:columns="columns"
				row-key="id"
				flat
				bordered
				:loading="propertyStore.loading"
				:pagination="pagination"
				@request="onRequest"
			>
				<!-- Coluna de ações -->
				<template #body-cell-actions="props">
					<q-td class="text-center">
						<q-btn
							icon="visibility"
							size="sm"
							round
							flat
							color="primary"
							@click="viewProperty(props.row.id)"
						/>

						<q-btn
							icon="edit"
							size="sm"
							round
							flat
							color="secondary"
							@click="editProperty(props.row.id)"
						/>

						<q-btn
							icon="delete"
							size="sm"
							round
							flat
							color="negative"
							@click="deleteProperty(props.row.id)"
						/>

						<q-btn
							icon="star"
							size="sm"
							round
							flat
							:color="props.row.featured ? 'yellow-8' : 'grey'"
							@click="toggleFeatured(props.row.id)"
						/>
					</q-td>
				</template>

				<!-- Coluna de imagens -->
				<template #body-cell-image="props">
					<q-td>
						<q-avatar square size="50px">
							<img :src="props.row.images?.[0]?.url || '/no-image.png'" />
						</q-avatar>
					</q-td>
				</template>
			</q-table>
		</q-card>
	</q-page>
</template>

<script setup lang="ts">
	import { ref, onMounted } from "vue";
	import { useRouter } from "vue-router";
	import type { QTableProps } from "quasar";
	import { useQuasar } from "quasar";
	import { usePropertyStore } from "src/stores/property";

	const router = useRouter();
	const $q = useQuasar();
	const propertyStore = usePropertyStore();

	const filters = ref({
		search: "",
		type: "",
		status: "",
		city: "",
		page: 1,
		limit: 10,
	});

	// Opções dos selects
	const propertyTypes = [
		{ label: "Casa", value: "CASA" },
		{ label: "Apartamento", value: "APARTAMENTO" },
		{ label: "Terreno", value: "TERRENO" },
		{ label: "Comercial", value: "COMERCIAL" },
		{ label: "Rural", value: "RURAL" },
	];

	const propertyStatus = [
		{ label: "Disponível", value: "DISPONIVEL" },
		{ label: "Reservado", value: "RESERVADO" },
		{ label: "Vendido", value: "VENDIDO" },
		{ label: "Alugado", value: "ALUGADO" },
		{ label: "Inativo", value: "INATIVO" },
	];

	// Colunas da tabela
	const columns: QTableProps["columns"] = [
		{ name: "image", label: "Foto", field: "image", align: "left" },
		{ name: "title", label: "Título", field: "title", align: "left", sortable: true },
		{ name: "type", label: "Tipo", field: "type", align: "left", sortable: true },
		{ name: "city", label: "Cidade", field: "city", align: "left", sortable: true },
		{ name: "status", label: "Status", field: "status", align: "left", sortable: true },
		{
			name: "priceSale",
			label: "Venda",
			field: "priceSale",
			align: "right",
			sortable: true,
		},
		{
			name: "priceRent",
			label: "Aluguel",
			field: "priceRent",
			align: "right",
			sortable: true,
		},
		{ name: "actions", label: "Ações", field: "actions", align: "center" },
	];

	const pagination = ref({
		page: 1,
		rowsPerPage: 10,
	});

	// Busca os imóveis do backend
	const loadProperties = async () => {
		await propertyStore.fetchProperties({
			...filters.value,
			page: pagination.value.page,
			limit: pagination.value.rowsPerPage,
		});
	};

	// Quando muda paginação
	const onRequest = async (props: any) => {
		pagination.value.page = props.pagination.page;
		pagination.value.rowsPerPage = props.pagination.rowsPerPage;
		await loadProperties();
	};

	// Ações
	const viewProperty = async (id: string) => {
		await router.push({ name: "property-detail", params: { id } });
	};

	const editProperty = async (id: string) => {
		await router.push({ name: "property-edit", params: { id } });
	};

	const deleteProperty = (id: string) => {
		$q.dialog({
			title: "Excluir imóvel",
			message: "Tem certeza que deseja excluir este imóvel?",
			cancel: true,
			persistent: true,
			// eslint-disable-next-line @typescript-eslint/no-misused-promises
		}).onOk(async () => {
			await propertyStore.deleteProperty(id);
			void loadProperties();

			$q.notify({
				type: "positive",
				message: "Imóvel excluído com sucesso",
			});
		});
	};

	const toggleFeatured = async (id: string): Promise<void> => {
		await propertyStore.toggleFeatured(id);
		$q.notify({
			type: "info",
			message: "Status de destaque atualizado",
		});
	};

	onMounted(async () => {
		await loadProperties();
	});
</script>
