<template>
	<q-page class="q-pa-md">
		<div class="row justify-center">
			<div class="col-12 col-lg-10">
				<!-- Header -->
				<div class="row items-center justify-between q-mb-md">
					<div class="text-h5">
						{{ isEditing ? "Editar Imóvel" : "Novo Imóvel" }}
					</div>
					<q-btn icon="close" flat round @click="router.back()" />
				</div>

				<!-- Formulário -->
				<q-form @submit="handleSubmit" class="q-gutter-md">
					<!-- Informações Básicas -->
					<q-card flat bordered>
						<q-card-section class="bg-primary text-white">
							<div class="text-h6">Informações Básicas</div>
						</q-card-section>

						<q-card-section class="q-gutter-md">
							<div class="row q-col-gutter-md">
								<div class="col-12">
									<q-input
										v-model="form.title"
										label="Título do imóvel"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12">
									<q-input
										v-model="form.description"
										label="Descrição"
										outlined
										type="textarea"
										rows="4"
									/>
								</div>

								<div class="col-12 col-md-3">
									<q-select
										v-model="form.type"
										:options="propertyTypes"
										label="Tipo de imóvel"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-3">
									<q-select
										v-model="form.transactionType"
										:options="transactionTypes"
										label="Tipo de transação"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-3">
									<q-select
										v-model="form.status"
										:options="statusOptions"
										label="Status"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-3">
									<q-toggle
										v-model="form.featured"
										label="Destacar imóvel"
										color="primary"
									/>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Localização -->
					<q-card flat bordered>
						<q-card-section class="bg-secondary text-white">
							<div class="text-h6">Localização</div>
						</q-card-section>

						<q-card-section class="q-gutter-md">
							<div class="row q-col-gutter-md">
								<div class="col-12">
									<q-input
										v-model="form.address"
										label="Endereço"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-4">
									<q-input
										v-model="form.neighborhood"
										label="Bairro"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-4">
									<q-input
										v-model="form.city"
										label="Cidade"
										outlined
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-2">
									<q-input
										v-model="form.state"
										label="Estado"
										outlined
										maxlength="2"
										:rules="[(val) => !!val || 'Campo obrigatório']"
									/>
								</div>

								<div class="col-12 col-md-2">
									<q-input v-model="form.zipCode" label="CEP" outlined mask="#####-###" />
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Características -->
					<q-card flat bordered>
						<q-card-section class="bg-accent text-white">
							<div class="text-h6">Características</div>
						</q-card-section>

						<q-card-section class="q-gutter-md">
							<div class="row q-col-gutter-md">
								<div class="col-12 col-md-3">
									<q-input
										v-model.number="form.areaTotal"
										label="Área total (m²)"
										outlined
										type="number"
										step="0.01"
									/>
								</div>

								<div class="col-12 col-md-3">
									<q-input
										v-model.number="form.areaBuilt"
										label="Área construída (m²)"
										outlined
										type="number"
										step="0.01"
									/>
								</div>

								<div class="col-12 col-md-2">
									<q-input
										v-model.number="form.bedrooms"
										label="Quartos"
										outlined
										type="number"
										min="0"
									/>
								</div>

								<div class="col-12 col-md-2">
									<q-input
										v-model.number="form.bathrooms"
										label="Banheiros"
										outlined
										type="number"
										min="0"
									/>
								</div>

								<div class="col-12 col-md-2">
									<q-input
										v-model.number="form.garage"
										label="Garagens"
										outlined
										type="number"
										min="0"
									/>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Preços -->
					<q-card flat bordered>
						<q-card-section class="bg-positive text-white">
							<div class="text-h6">Preços</div>
						</q-card-section>

						<q-card-section class="q-gutter-md">
							<div class="row q-col-gutter-md">
								<div
									class="col-12 col-md-6"
									v-if="
										form.transactionType === 'VENDA' || form.transactionType === 'AMBOS'
									"
								>
									<q-input
										v-model.number="form.priceSale"
										label="Preço de venda"
										outlined
										type="number"
										step="0.01"
										prefix="R$ "
									/>
								</div>

								<div
									class="col-12 col-md-6"
									v-if="
										form.transactionType === 'ALUGUEL' || form.transactionType === 'AMBOS'
									"
								>
									<q-input
										v-model.number="form.priceRent"
										label="Preço de aluguel"
										outlined
										type="number"
										step="0.01"
										prefix="R$ "
									/>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Botões de Ação -->
					<div class="row q-col-gutter-md">
						<div class="col-12 col-md-6">
							<q-btn
								label="Cancelar"
								outline
								color="grey"
								class="full-width"
								@click="router.back()"
							/>
						</div>

						<div class="col-12 col-md-6">
							<q-btn
								label="Salvar"
								color="primary"
								type="submit"
								class="full-width"
								:loading="loading"
								:disable="loading"
							/>
						</div>
					</div>
				</q-form>
			</div>
		</div>
	</q-page>
</template>

<script setup lang="ts">
	import { ref, reactive, onMounted } from "vue";
	import { useRouter, useRoute } from "vue-router";
	import { useQuasar } from "quasar";
	import type {
		Property,
		PropertyType,
		TransactionType,
		PropertyStatus,
	} from "src/stores/property";
	import { usePropertyStore } from "src/stores/property";

	const router = useRouter();
	const route = useRoute();
	const $q = useQuasar();
	const propertyStore = usePropertyStore();

	const loading = ref(false);
	const isEditing = ref(false);

	// Opções dos selects
	const propertyTypes: Array<{ label: string; value: PropertyType }> = [
		{ label: "Casa", value: "CASA" },
		{ label: "Apartamento", value: "APARTAMENTO" },
		{ label: "Terreno", value: "TERRENO" },
		{ label: "Comercial", value: "COMERCIAL" },
		{ label: "Rural", value: "RURAL" },
	];

	const transactionTypes: Array<{ label: string; value: TransactionType }> = [
		{ label: "Venda", value: "VENDA" },
		{ label: "Aluguel", value: "ALUGUEL" },
		{ label: "Ambos", value: "AMBOS" },
	];

	const statusOptions: Array<{ label: string; value: PropertyStatus }> = [
		{ label: "Disponível", value: "DISPONIVEL" },
		{ label: "Reservado", value: "RESERVADO" },
		{ label: "Vendido", value: "VENDIDO" },
		{ label: "Alugado", value: "ALUGADO" },
		{ label: "Inativo", value: "INATIVO" },
	];

	// Formulário
	const form = reactive<Partial<Property>>({
		title: "",
		description: "",
		type: "CASA",
		transactionType: "VENDA",
		status: "DISPONIVEL",
		address: "",
		neighborhood: "",
		city: "",
		state: "",
		zipCode: "",
		areaTotal: undefined,
		areaBuilt: undefined,
		bedrooms: 0,
		bathrooms: 0,
		garage: 0,
		priceSale: undefined,
		priceRent: undefined,
		featured: false,
	});

	// Carregar dados se for edição
	const loadProperty = async (): Promise<void> => {
		const propertyId = route.params.id as string;

		if (!propertyId) return;

		loading.value = true;

		try {
			const property = await propertyStore.fetchPropertyById(propertyId);

			Object.assign(form, property);
			isEditing.value = true;
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		} catch (error) {
			$q.notify({
				type: "negative",
				message: "Erro ao carregar imóvel",
				position: "top",
			});
			router.back();
		} finally {
			loading.value = false;
		}
	};

	// Submeter formulário
	const handleSubmit = async (): Promise<void> => {
		loading.value = true;

		try {
			if (isEditing.value && form.id) {
				await propertyStore.updateProperty(form.id, form);

				$q.notify({
					type: "positive",
					message: "Imóvel atualizado com sucesso",
					position: "top",
				});
			} else {
				await propertyStore.createProperty(form);

				$q.notify({
					type: "positive",
					message: "Imóvel cadastrado com sucesso",
					position: "top",
				});
			}

			await router.push({ name: "properties" });
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		} catch (error) {
			$q.notify({
				type: "negative",
				message: propertyStore.error || "Erro ao salvar imóvel",
				position: "top",
			});
		} finally {
			loading.value = false;
		}
	};

	onMounted(async () => {
		await loadProperty();
	});
</script>
