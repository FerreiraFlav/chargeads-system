<template>
  <div class="monitores-page">
    <div class="page-header">
      <h1 class="page-title">Monitores</h1>
      <p class="page-subtitle">Gerenciamento de monitores conectados</p>
    </div>

    <div class="card">
      <div class="card-header">
        <h5>Lista de Monitores</h5>
        <div class="card-actions">
          <button class="btn btn-primary">
            <i class="fas fa-plus"></i> Novo Monitor
          </button>
        </div>
      </div>
      <div class="card-body">
        <p>Conteúdo da página de monitores será exibido aqui.</p>
        <p>Esta página mostrará todos os monitores conectados ao sistema.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
// Component logic here
</script>

<style scoped>
.monitores-page {
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

