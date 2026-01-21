<template>
	<q-page class="q-pa-md">
		<div class="row justify-center">
			<div class="col-12 col-lg-10">
				<!-- Header -->
				<div class="row items-center justify-between q-mb-md">
					<div class="text-h5">Detalhes do Imóvel</div>
					<q-btn icon="arrow_back" flat round @click="router.back()" />
				</div>

				<q-inner-loading :showing="propertyStore.loading">
					<q-spinner-gears size="50px" color="primary" />
				</q-inner-loading>

				<q-card v-if="property" flat bordered>
					<q-card-section class="q-pa-none">
						<!-- Carrossel de Imagens -->
						<q-carousel
							v-model="slide"
							animated
							control-type="flat"
							control-color="white"
							navigation
							infinite
							arrows
							height="400px"
							class="bg-dark text-white rounded-borders"
						>
							<q-carousel-slide
								v-for="(image, index) in property.images"
								:key="image.id"
								:name="index"
								:img-src="image.url"
								class="bg-cover"
							>
								<div class="absolute-bottom custom-caption">
									<div class="text-h6">{{ property.title }}</div>
									<div class="text-subtitle1">
										{{ property.city }} - {{ property.state }}
									</div>
								</div>
							</q-carousel-slide>
							<q-carousel-slide
								v-if="!property.images || property.images.length === 0"
								:name="0"
								img-src="https://via.placeholder.com/800x400?text=Sem+Imagem"
								class="bg-cover"
							>
								<div class="absolute-bottom custom-caption">
									<div class="text-h6">{{ property.title }}</div>
									<div class="text-subtitle1">
										{{ property.city }} - {{ property.state }}
									</div>
								</div>
							</q-carousel-slide>
						</q-carousel>
					</q-card-section>

					<q-card-section>
						<div class="text-h5 q-mb-sm">{{ property.title }}</div>
						<div class="text-subtitle1 text-grey-8 q-mb-md">
							{{ property.address }}, {{ property.neighborhood }}, {{ property.city }} -
							{{ property.state }}
							<span v-if="property.zipCode"> (CEP: {{ property.zipCode }})</span>
						</div>

						<div class="row q-col-gutter-md q-mb-md">
							<div class="col-12 col-md-6">
								<q-chip
									icon="sell"
									color="primary"
									text-color="white"
									v-if="
										property.transactionType === 'VENDA' ||
										property.transactionType === 'AMBOS'
									"
								>
									Venda: R$ {{ formatPrice(property.priceSale) }}
								</q-chip>
								<q-chip
									icon="payments"
									color="accent"
									text-color="white"
									v-if="
										property.transactionType === 'ALUGUEL' ||
										property.transactionType === 'AMBOS'
									"
								>
									Aluguel: R$ {{ formatPrice(property.priceRent) }} / mês
								</q-chip>
							</div>
							<div class="col-12 col-md-6 text-right">
								<q-chip icon="category" color="blue-grey-7" text-color="white">
									Tipo: {{ propertyTypeLabel(property.type) }}
								</q-chip>
								<q-chip
									icon="info"
									:color="property.status === 'DISPONIVEL' ? 'green' : 'orange'"
									text-color="white"
								>
									Status: {{ propertyStatusLabel(property.status) }}
								</q-chip>
								<q-chip
									icon="star"
									color="yellow-9"
									text-color="white"
									v-if="property.featured"
								>
									Destaque
								</q-chip>
							</div>
						</div>

						<q-separator class="q-my-md" />

						<div class="text-h6 q-mb-sm">Características</div>
						<div class="row q-col-gutter-md">
							<div class="col-12 col-sm-6 col-md-4" v-if="property.bedrooms">
								<q-item dense>
									<q-item-section avatar
										><q-icon name="king_bed" color="grey-7"
									/></q-item-section>
									<q-item-section>Quartos: {{ property.bedrooms }}</q-item-section>
								</q-item>
							</div>
							<div class="col-12 col-sm-6 col-md-4" v-if="property.bathrooms">
								<q-item dense>
									<q-item-section avatar
										><q-icon name="bathtub" color="grey-7"
									/></q-item-section>
									<q-item-section>Banheiros: {{ property.bathrooms }}</q-item-section>
								</q-item>
							</div>
							<div class="col-12 col-sm-6 col-md-4" v-if="property.garage">
								<q-item dense>
									<q-item-section avatar
										><q-icon name="directions_car" color="grey-7"
									/></q-item-section>
									<q-item-section>Vagas na Garagem: {{ property.garage }}</q-item-section>
								</q-item>
							</div>
							<div class="col-12 col-sm-6 col-md-4" v-if="property.areaTotal">
								<q-item dense>
									<q-item-section avatar
										><q-icon name="square_foot" color="grey-7"
									/></q-item-section>
									<q-item-section>Área Total: {{ property.areaTotal }} m²</q-item-section>
								</q-item>
							</div>
							<div class="col-12 col-sm-6 col-md-4" v-if="property.areaBuilt">
								<q-item dense>
									<q-item-section avatar
										><q-icon name="architecture" color="grey-7"
									/></q-item-section>
									<q-item-section
										>Área Construída: {{ property.areaBuilt }} m²</q-item-section
									>
								</q-item>
							</div>
						</div>

						<q-separator class="q-my-md" />

						<div class="text-h6 q-mb-sm">Descrição Detalhada</div>
						<p>{{ property.description || "Nenhuma descrição detalhada fornecida." }}</p>

						<q-separator class="q-my-md" />

						<!-- Botão de Agendamento de Visita -->
						<div v-if="property.status === 'DISPONIVEL'" class="q-mt-md">
							<q-btn
								label="Agendar Visita"
								icon="event"
								color="positive"
								size="lg"
								@click="openScheduleDialog"
								class="full-width"
							/>
						</div>

						<div class="text-caption text-grey-6 q-mt-md">
							Cadastrado em: {{ formatDate(property.createdAt) }} por
							{{ property.user?.name || "Usuário Desconhecido" }}
						</div>
						<div class="text-caption text-grey-6">
							Última atualização: {{ formatDate(property.updatedAt) }}
						</div>
					</q-card-section>

					<q-card-actions align="right" v-if="authStore.isAdmin">
						<q-btn
							flat
							label="Editar Imóvel"
							icon="edit"
							color="primary"
							@click="editProperty(property.id)"
						/>
						<q-btn
							flat
							label="Excluir Imóvel"
							icon="delete"
							color="negative"
							@click="confirmDelete(property.id)"
						/>
					</q-card-actions>
				</q-card>

				<div
					v-else-if="!propertyStore.loading && propertyStore.error"
					class="text-center q-mt-xl text-negative"
				>
					<q-icon name="error" size="xl" />
					<div class="text-h6 q-mt-sm">{{ propertyStore.error }}</div>
				</div>
			</div>
		</div>

		<!-- Diálogo de Agendamento de Visita -->
		<q-dialog v-model="showScheduleDialog" persistent>
			<q-card style="min-width: 400px">
				<q-card-section>
					<div class="text-h6">Agendar Visita</div>
				</q-card-section>

				<q-card-section class="q-pt-none">
					<q-input
						v-model="scheduleForm.name"
						label="Seu Nome *"
						outlined
						dense
						:rules="[(val: string) => !!val || 'Nome é obrigatório']"
					/>
					<q-input
						v-model="scheduleForm.email"
						label="Seu E-mail *"
						outlined
						dense
						type="email"
						class="q-mt-sm"
						:rules="[(val: string) => !!val || 'E-mail é obrigatório']"
					/>
					<q-input
						v-model="scheduleForm.phone"
						label="Seu Telefone *"
						outlined
						dense
						mask="(##) #####-####"
						class="q-mt-sm"
						:rules="[(val: string) => !!val || 'Telefone é obrigatório']"
					/>
					<q-input
						v-model="scheduleForm.date"
						label="Data da Visita *"
						outlined
						dense
						type="date"
						class="q-mt-sm"
						:rules="[(val: string) => !!val || 'Data é obrigatória']"
					/>
					<q-input
						v-model="scheduleForm.time"
						label="Horário da Visita *"
						outlined
						dense
						type="time"
						class="q-mt-sm"
						:rules="[(val: string) => !!val || 'Horário é obrigatório']"
					/>
					<q-input
						v-model="scheduleForm.message"
						label="Mensagem (Opcional)"
						outlined
						dense
						type="textarea"
						rows="3"
						class="q-mt-sm"
					/>
				</q-card-section>

				<q-card-actions align="right">
					<q-btn flat label="Cancelar" color="grey" v-close-popup />
					<q-btn
						flat
						label="Confirmar Agendamento"
						color="positive"
						@click="submitSchedule"
						:loading="scheduleLoading"
					/>
				</q-card-actions>
			</q-card>
		</q-dialog>
	</q-page>
</template>

<script setup lang="ts">
	import { ref, onMounted, computed } from "vue";
	import { useRoute, useRouter } from "vue-router";
	import type { PropertyType, PropertyStatus } from "src/stores/property";
	import { usePropertyStore } from "src/stores/property";
	import { useAuthStore } from "src/stores/auth";
	import { Notify, Dialog } from "quasar";

	interface ScheduleForm {
		name: string;
		email: string;
		phone: string;
		date: string;
		time: string;
		message: string;
	}

	const route = useRoute();
	const router = useRouter();
	const propertyStore = usePropertyStore();
	const authStore = useAuthStore();

	const propertyId = ref<string>(route.params.id as string);
	const slide = ref(0);
	const showScheduleDialog = ref(false);
	const scheduleLoading = ref(false);

	const scheduleForm = ref<ScheduleForm>({
		name: "",
		email: "",
		phone: "",
		date: "",
		time: "",
		message: "",
	});

	const property = computed(() => propertyStore.currentProperty);

	const loadPropertyDetails = async (): Promise<void> => {
		try {
			await propertyStore.fetchPropertyById(propertyId.value);
		} catch (error: unknown) {
			console.error("Erro ao carregar detalhes do imóvel:", error);
			Notify.create({
				type: "negative",
				message:
					propertyStore.error || "Não foi possível carregar os detalhes do imóvel.",
				position: "top-right",
			});
		}
	};

	const propertyTypeLabel = (type: PropertyType): string => {
		const labels: Record<PropertyType, string> = {
			CASA: "Casa",
			APARTAMENTO: "Apartamento",
			TERRENO: "Terreno",
			COMERCIAL: "Comercial",
			RURAL: "Rural",
		};
		return labels[type] || type;
	};

	const propertyStatusLabel = (status: PropertyStatus): string => {
		const labels: Record<PropertyStatus, string> = {
			DISPONIVEL: "Disponível",
			RESERVADO: "Reservado",
			VENDIDO: "Vendido",
			ALUGADO: "Alugado",
			INATIVO: "Inativo",
		};
		return labels[status] || status;
	};

	const formatPrice = (price: number | undefined): string => {
		if (!price) return "0,00";
		return price.toLocaleString("pt-BR", {
			minimumFractionDigits: 2,
			maximumFractionDigits: 2,
		});
	};

	const formatDate = (dateString: string): string => {
		return new Date(dateString).toLocaleDateString("pt-BR");
	};

	const editProperty = async (id: string) => {
		await router.push({ name: "property-edit", params: { id } });
	};

	const confirmDelete = async (id: string) => {
		Dialog.create({
			title: "Confirmar Exclusão",
			message:
				"Tem certeza que deseja excluir este imóvel? Esta ação não pode ser desfeita.",
			cancel: true,
			persistent: true,
		}).onOk(async () => {
			try {
				await propertyStore.deleteProperty(id);
				Notify.create({
					type: "positive",
					message: "Imóvel excluído com sucesso!",
					position: "top-right",
				});
				await router.push({ name: "properties" });
			} catch (error: unknown) {
				console.error("Erro ao excluir imóvel:", error);
				Notify.create({
					type: "negative",
					message: propertyStore.error || "Erro ao excluir imóvel.",
					position: "top-right",
				});
			}
		});
	};

	const openScheduleDialog = (): void => {
		showScheduleDialog.value = true;
	};

	const submitSchedule = async (): Promise<void> => {
		scheduleLoading.value = true;
		try {
			// Aqui você pode enviar os dados do agendamento para o backend
			// Por enquanto, vamos apenas simular o envio
			await new Promise((resolve) => setTimeout(resolve, 1500));

			Notify.create({
				type: "positive",
				message: "Agendamento realizado com sucesso! Entraremos em contato em breve.",
				position: "top-right",
			});

			showScheduleDialog.value = false;
			scheduleForm.value = {
				name: "",
				email: "",
				phone: "",
				date: "",
				time: "",
				message: "",
			};
		} catch (error: unknown) {
			console.error("Erro ao agendar visita:", error);
			Notify.create({
				type: "negative",
				message: "Erro ao agendar visita. Tente novamente.",
				position: "top-right",
			});
		} finally {
			scheduleLoading.value = false;
		}
	};

	onMounted(() => {
		if (propertyId.value) {
			loadPropertyDetails();
		} else {
			Notify.create({
				type: "negative",
				message: "ID do imóvel não fornecido.",
				position: "top-right",
			});
			router.push({ name: "properties" });
		}
	});
</script>

<style scoped>
	.custom-caption {
		text-align: center;
		padding: 12px;
		color: white;
		background-color: rgba(0, 0, 0, 0.5);
	}

	.bg-cover {
		background-size: cover;
		background-position: center;
	}
</style>
