<script setup lang="ts">
import { ref, onMounted } from 'vue';
import apiClient from './services/api';

interface BackendResponse {
  message: string;
  database: string;
  timestamp: string;
  environment: string;
}

const backendStatus = ref<string>('Conectando...');
const backendData = ref<BackendResponse | null>(null);
const error = ref<string>('');

const testConnection = async () => {
  try {
    const response = await apiClient.get<BackendResponse>('/test');
    backendStatus.value = 'Conectado ✓';
    backendData.value = response.data;
    error.value = '';
  } catch (err) {
    backendStatus.value = 'Error de conexión ✗';
    error.value = err instanceof Error ? err.message : 'Error desconocido';
  }
};

onMounted(() => {
  testConnection();
});
</script>

<template>
  <div class="app">
    <h1>🚀 Proyecto Laravel + PostgreSQL + Vue TypeScript</h1>
    
    <div class="status-card">
      <h2>Estado de Conexión Backend</h2>
      <p class="status" :class="{ 'connected': backendStatus.includes('✓'), 'error': backendStatus.includes('✗') }">
        {{ backendStatus }}
      </p>
      
      <div v-if="backendData" class="data">
        <h3>Respuesta del Backend:</h3>
        <pre>{{ JSON.stringify(backendData, null, 2) }}</pre>
      </div>
      
      <div v-if="error" class="error-message">
        <p><strong>Error:</strong> {{ error }}</p>
      </div>
      
      <button @click="testConnection" class="btn">🔄 Reintentar Conexión</button>
    </div>
  </div>
</template>

<style scoped>
.app {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}

h1 {
  color: #42b883;
  margin-bottom: 2rem;
}

.status-card {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.status {
  font-size: 1.5rem;
  font-weight: bold;
  margin: 1rem 0;
}

.status.connected {
  color: #42b883;
}

.status.error {
  color: #e74c3c;
}

.data {
  background: white;
  border-radius: 4px;
  padding: 1rem;
  margin: 1rem 0;
  text-align: left;
}

.data pre {
  overflow-x: auto;
}

.error-message {
  background: #fee;
  border-left: 4px solid #e74c3c;
  padding: 1rem;
  margin: 1rem 0;
  text-align: left;
}

.btn {
  background: #42b883;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
  margin-top: 1rem;
  transition: background 0.3s;
}

.btn:hover {
  background: #35a372;
}
</style>
