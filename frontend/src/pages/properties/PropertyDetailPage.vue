<template>
	<q-page class="q-pa-md">
		<div class="row justify-center">
			<div class="col-12 col-lg-10">
				<!-- Header -->
				<div class="row items-center justify-between q-mb-md">
					<div class="text-h5">Detalhes do Imóvel</div>
					<div class="row q-gutter-sm">
						<q-btn icon="edit" color="secondary" @click="editProperty" v-if="property" />
						<q-btn icon="close" flat round @click="router.back()" />
					</div>
				</div>

				<!-- Loading -->
				<div v-if="loading" class="text-center q-my-lg">
					<q-spinner color="primary" size="50px" />
				</div>

				<!-- Conteúdo -->
				<template v-else-if="property">
					<!-- Galeria de Imagens -->
					<q-card flat bordered class="q-mb-md">
						<div class="relative-position">
							<!-- Imagem Principal -->
							<div
								class="relative-position bg-grey-2"
								style="height: 400px; overflow: hidden"
							>
								<img
									:src="currentImage?.url || '/no-image.png'"
									class="fit"
									style="width: 100%; height: 100%; object-fit: cover"
								/>

								<!-- Badge de Destaque -->
								<div v-if="property.featured" class="absolute-top-right q-ma-md">
									<q-badge color="yellow-8" text-color="black" icon="star">
										Destaque
									</q-badge>
								</div>

								<!-- Badge de Status -->
								<div class="absolute-bottom-left q-ma-md">
									<q-badge :color="getStatusColor(property.status)">
										{{ getStatusLabel(property.status) }}
									</q-badge>
								</div>
							</div>

							<!-- Miniaturas -->
							<q-card-section class="q-pa-md bg-grey-1">
								<div class="row q-gutter-sm">
									<div
										v-for="(image, index) in property.images"
										:key="image.id"
										class="cursor-pointer"
										@click="currentImageIndex = index"
									>
										<q-img
											:src="image.url"
											style="width: 80px; height: 80px; border-radius: 4px"
											:class="{ 'border-2 border-primary': currentImageIndex === index }"
										/>
									</div>

									<!-- Botão para adicionar imagens -->
									<div
										class="flex flex-center"
										style="
											width: 80px;
											height: 80px;
											border: 2px dashed #ccc;
											border-radius: 4px;
											cursor: pointer;
										"
										@click="uploadImages"
									>
										<q-icon name="add_photo_alternate" size="32px" color="grey-6" />
									</div>
								</div>
							</q-card-section>
						</div>
					</q-card>

					<!-- Informações Principais -->
					<q-card flat bordered class="q-mb-md">
						<q-card-section>
							<div class="text-h6 q-mb-md">{{ property.title }}</div>

							<div class="row q-col-gutter-lg">
								<!-- Preços -->
								<div class="col-12 col-md-6">
									<div v-if="property.priceSale" class="q-mb-md">
										<div class="text-caption text-grey-7">Preço de Venda</div>
										<div class="text-h6 text-positive">
											{{ formatCurrency(property.priceSale) }}
										</div>
									</div>

									<div v-if="property.priceRent">
										<div class="text-caption text-grey-7">Preço de Aluguel</div>
										<div class="text-h6 text-info">
											{{ formatCurrency(property.priceRent) }} /mês
										</div>
									</div>
								</div>

								<!-- Informações Rápidas -->
								<div class="col-12 col-md-6">
									<div class="row q-col-gutter-md">
										<div class="col-6 col-md-3" v-if="property.bedrooms">
											<div class="text-caption text-grey-7">Quartos</div>
											<div class="text-h6">{{ property.bedrooms }}</div>
										</div>

										<div class="col-6 col-md-3" v-if="property.bathrooms">
											<div class="text-caption text-grey-7">Banheiros</div>
											<div class="text-h6">{{ property.bathrooms }}</div>
										</div>

										<div class="col-6 col-md-3" v-if="property.garage">
											<div class="text-caption text-grey-7">Garagens</div>
											<div class="text-h6">{{ property.garage }}</div>
										</div>

										<div class="col-6 col-md-3" v-if="property.areaTotal">
											<div class="text-caption text-grey-7">Área Total</div>
											<div class="text-h6">{{ property.areaTotal }}m²</div>
										</div>
									</div>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Descrição -->
					<q-card flat bordered class="q-mb-md" v-if="property.description">
						<q-card-section class="bg-grey-1">
							<div class="text-subtitle2 q-mb-sm">Descrição</div>
							<div class="text-body2">{{ property.description }}</div>
						</q-card-section>
					</q-card>

					<!-- Localização -->
					<q-card flat bordered class="q-mb-md">
						<q-card-section class="bg-secondary text-white">
							<div class="text-h6">Localização</div>
						</q-card-section>

						<q-card-section class="q-gutter-md">
							<div class="row q-col-gutter-md">
								<div class="col-12 col-md-6">
									<div class="text-caption text-grey-7">Endereço</div>
									<div class="text-body2">{{ property.address }}</div>
								</div>

								<div class="col-12 col-md-6">
									<div class="text-caption text-grey-7">Bairro</div>
									<div class="text-body2">{{ property.neighborhood }}</div>
								</div>

								<div class="col-12 col-md-4">
									<div class="text-caption text-grey-7">Cidade</div>
									<div class="text-body2">{{ property.city }} - {{ property.state }}</div>
								</div>

								<div class="col-12 col-md-4">
									<div class="text-caption text-grey-7">CEP</div>
									<div class="text-body2">{{ property.zipCode }}</div>
								</div>

								<div class="col-12 col-md-4">
									<div class="text-caption text-grey-7">Tipo</div>
									<div class="text-body2">{{ property.type }}</div>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Características -->
					<q-card flat bordered class="q-mb-md">
						<q-card-section class="bg-accent text-white">
							<div class="text-h6">Características</div>
						</q-card-section>

						<q-card-section class="q-gutter-md">
							<div class="row q-col-gutter-md">
								<div class="col-12 col-md-3" v-if="property.areaTotal">
									<div class="text-caption text-grey-7">Área Total</div>
									<div class="text-body2 text-weight-bold">
										{{ property.areaTotal }} m²
									</div>
								</div>

								<div class="col-12 col-md-3" v-if="property.areaBuilt">
									<div class="text-caption text-grey-7">Área Construída</div>
									<div class="text-body2 text-weight-bold">
										{{ property.areaBuilt }} m²
									</div>
								</div>

								<div class="col-12 col-md-3" v-if="property.bedrooms">
									<div class="text-caption text-grey-7">Quartos</div>
									<div class="text-body2 text-weight-bold">{{ property.bedrooms }}</div>
								</div>

								<div class="col-12 col-md-3" v-if="property.bathrooms">
									<div class="text-caption text-grey-7">Banheiros</div>
									<div class="text-body2 text-weight-bold">{{ property.bathrooms }}</div>
								</div>

								<div class="col-12 col-md-3" v-if="property.garage">
									<div class="text-caption text-grey-7">Garagens</div>
									<div class="text-body2 text-weight-bold">{{ property.garage }}</div>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Informações do Corretor -->
					<q-card flat bordered v-if="property.user">
						<q-card-section class="bg-primary text-white">
							<div class="text-h6">Informações do Corretor</div>
						</q-card-section>

						<q-card-section>
							<div class="row items-center q-gutter-md">
								<q-avatar size="60px">
									<img src="https://cdn.quasar.dev/img/avatar.png" />
								</q-avatar>

								<div>
									<div class="text-body1 text-weight-bold">{{ property.user.name }}</div>
									<div class="text-caption text-grey-7">Corretor de Imóveis</div>
								</div>
							</div>
						</q-card-section>
					</q-card>

					<!-- Botões de Ação -->
					<div class="row q-col-gutter-md q-mt-md">
						<div class="col-12 col-md-6">
							<q-btn
								label="Editar"
								color="secondary"
								icon="edit"
								class="full-width"
								@click="editProperty"
							/>
						</div>

						<div class="col-12 col-md-6">
							<q-btn
								label="Excluir"
								color="negative"
								icon="delete"
								class="full-width"
								@click="deleteProperty"
							/>
						</div>
					</div>
				</template>

				<!-- Erro -->
				<q-card v-else flat bordered>
					<q-card-section class="text-center q-pa-lg">
						<q-icon name="error" size="48px" color="negative" />
						<div class="text-h6 q-mt-md">Imóvel não encontrado</div>
					</q-card-section>
				</q-card>
			</div>
		</div>

		<!-- Dialog de Upload de Imagens -->
		<q-dialog v-model="showUploadDialog">
			<q-card style="min-width: 400px">
				<q-card-section class="row items-center q-pb-none">
					<div class="text-h6">Upload de Imagens</div>
					<q-space />
					<q-btn icon="close" flat round dense v-close-popup />
				</q-card-section>

				<q-card-section>
					<q-file
						v-model="filesToUpload"
						label="Selecione as imagens"
						multiple
						@rejected="onFileRejected"
						accept="image/*"
						max-file-size="5242880"
					/>
				</q-card-section>

				<q-card-actions align="right">
					<q-btn label="Cancelar" color="grey" flat v-close-popup />
					<q-btn
						label="Upload"
						color="primary"
						@click="handleUpload"
						:loading="uploadingImages"
					/>
				</q-card-actions>
			</q-card>
		</q-dialog>
	</q-page>
</template>

<script setup lang="ts">
	import { ref, computed, onMounted } from "vue";
	import { useRouter, useRoute } from "vue-router";
	import { useQuasar } from "quasar";
	import type { Property, PropertyStatus } from "src/stores/property";
	import { usePropertyStore, PropertyImage } from "src/stores/property";

	const router = useRouter();
	const route = useRoute();
	const $q = useQuasar();
	const propertyStore = usePropertyStore();

	const loading = ref(false);
	const property = ref<Property | null>(null);
	const currentImageIndex = ref(0);
	const showUploadDialog = ref(false);
	const filesToUpload = ref<File[]>([]);
	const uploadingImages = ref(false);

	// Computed
	const currentImage = computed(() => {
		return property.value?.images?.[currentImageIndex.value];
	});

	// Funções de formatação
	const formatCurrency = (value: number | undefined): string => {
		if (!value) return "N/A";
		return new Intl.NumberFormat("pt-BR", {
			style: "currency",
			currency: "BRL",
		}).format(value);
	};

	const getStatusColor = (status: PropertyStatus): string => {
		const colors: Record<PropertyStatus, string> = {
			DISPONIVEL: "positive",
			RESERVADO: "warning",
			VENDIDO: "info",
			ALUGADO: "secondary",
			INATIVO: "negative",
		};
		return colors[status] || "grey";
	};

	const getStatusLabel = (status: PropertyStatus): string => {
		const labels: Record<PropertyStatus, string> = {
			DISPONIVEL: "Disponível",
			RESERVADO: "Reservado",
			VENDIDO: "Vendido",
			ALUGADO: "Alugado",
			INATIVO: "Inativo",
		};
		return labels[status] || status;
	};

	// Carregar imóvel
	const loadProperty = async (): Promise<void> => {
		const propertyId = route.params.id as string;

		if (!propertyId) {
			$q.notify({
				type: "negative",
				message: "ID do imóvel não fornecido",
			});
			router.back();
			return;
		}

		loading.value = true;

		try {
			property.value = await propertyStore.fetchPropertyById(propertyId);
		} catch (error) {
			$q.notify({
				type: "negative",
				message: "Erro ao carregar imóvel",
				position: "top",
			});
		} finally {
			loading.value = false;
		}
	};

	// Upload de imagens
	const uploadImages = (): void => {
		showUploadDialog.value = true;
	};

	const onFileRejected = (): void => {
		$q.notify({
			type: "negative",
			message: "Arquivo rejeitado. Máximo 5MB por imagem.",
			position: "top",
		});
	};

	const handleUpload = async (): Promise<void> => {
		if (!property.value || filesToUpload.value.length === 0) return;

		uploadingImages.value = true;

		try {
			await propertyStore.uploadImages(property.value.id, filesToUpload.value);

			$q.notify({
				type: "positive",
				message: "Imagens enviadas com sucesso",
				position: "top",
			});

			filesToUpload.value = [];
			showUploadDialog.value = false;

			// Recarregar imóvel
			await loadProperty();
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		} catch (error) {
			$q.notify({
				type: "negative",
				message: "Erro ao fazer upload de imagens",
				position: "top",
			});
		} finally {
			uploadingImages.value = false;
		}
	};

	// Editar imóvel
	const editProperty = async () => {
		if (property.value) {
			await router.push({
				name: "property-edit",
				params: { id: property.value.id },
			});
		}
	};

	// Excluir imóvel
	const deleteProperty = () => {
		$q.dialog({
			title: "Excluir imóvel",
			message:
				"Tem certeza que deseja excluir este imóvel? Esta ação não pode ser desfeita.",
			cancel: true,
			persistent: true,
			// eslint-disable-next-line @typescript-eslint/no-misused-promises
		}).onOk(async () => {
			if (!property.value) return;

			try {
				await propertyStore.deleteProperty(property.value.id);

				$q.notify({
					type: "positive",
					message: "Imóvel excluído com sucesso",
					position: "top",
				});

				await router.push({ name: "properties" });
				// eslint-disable-next-line @typescript-eslint/no-unused-vars
			} catch (error) {
				$q.notify({
					type: "negative",
					message: "Erro ao excluir imóvel",
					position: "top",
				});
			}
		});
	};

	onMounted(async () => {
		await loadProperty();
	});
</script>
