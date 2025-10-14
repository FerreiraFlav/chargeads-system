<template>
  <div class="configuracoes-page">
    <div class="page-header">
      <h1 class="page-title">Configurações</h1>
      <p class="page-subtitle">Configurações do sistema</p>
    </div>

    <div class="card">
      <div class="card-header">
        <h5>Configurações Gerais</h5>
      </div>
      <div class="card-body">
        <p>Conteúdo da página de configurações será exibido aqui.</p>
        <p>Esta página permitirá configurar as opções do sistema.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
// Component logic here
</script>

<style scoped>
.configuracoes-page {
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

