<template>
  <div class="programacoes-page">
    <div class="page-header">
      <h1 class="page-title">Programações</h1>
      <p class="page-subtitle">Agendamento de conteúdo</p>
    </div>

    <div class="card">
      <div class="card-header">
        <h5>Lista de Programações</h5>
        <div class="card-actions">
          <button class="btn btn-primary">
            <i class="fas fa-plus"></i> Nova Programação
          </button>
        </div>
      </div>
      <div class="card-body">
        <p>Conteúdo da página de programações será exibido aqui.</p>
        <p>Esta página mostrará todas as programações agendadas.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
// Component logic here
</script>

<style scoped>
.programacoes-page {
  width: 100%;
  height: 100%;
}

.page-header {
  margin-bottom: 2rem;
}

.page-title {
  font-size: 2rem;
  font-weight: 700;
  color: var(--cui-gray-800);
  margin-bottom: 0.5rem;
}

.page-subtitle {
  color: var(--cui-gray-600);
  margin-bottom: 0;
}
</style>

