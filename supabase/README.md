# ChargeADS - Supabase Database

Este diretório contém toda a estrutura de banco de dados do sistema ChargeADS usando Supabase.

## 📁 Estrutura de Arquivos

```
supabase/
├── migrations/
│   ├── 001_initial_schema.sql    # Schema inicial com todas as tabelas
│   └── 002_auth_functions.sql    # Funções de autenticação e RLS
├── seed.sql                      # Dados iniciais para desenvolvimento
├── config.toml                   # Configuração do Supabase
└── README.md                     # Esta documentação
```

## 🗄️ Schema do Banco de Dados

### 👥 Tabelas de Usuários
- **`users`** - Extensão da tabela auth.users do Supabase
- **`user_profiles`** - Informações adicionais do perfil do usuário

### 🖥️ Tabelas de Players
- **`players`** - Dispositivos de sinalização digital
- **`player_statistics`** - Estatísticas e dados de uptime
- **`player_logs`** - Log de mudanças de status dos players

### 📁 Tabelas de Mídia
- **`media_files`** - Arquivos de mídia carregados
- **`playlists`** - Listas de reprodução
- **`playlist_items`** - Itens dentro das playlists

### 📅 Tabelas de Agendamento
- **`schedules`** - Regras de agendamento
- **`schedule_assignments`** - Atribuição de agendamentos aos players

### ⚙️ Tabelas do Sistema
- **`system_settings`** - Configurações do sistema
- **`audit_logs`** - Log de auditoria

## 🔐 Autenticação e Segurança

### Row Level Security (RLS)
Todas as tabelas têm RLS habilitado com políticas específicas:
- **Usuários**: Podem ver/editar apenas seu próprio perfil
- **Admins**: Acesso total a todas as tabelas
- **Usuários autenticados**: Acesso de leitura a dados públicos

### Funções de Autenticação
- `get_user_profile()` - Retorna perfil do usuário atual
- `update_user_profile()` - Atualiza perfil do usuário
- `is_admin()` - Verifica se usuário é admin
- `log_user_activity()` - Registra atividades do usuário

## 🚀 Como Usar

### 1. Aplicar Migrações
```bash
# Usando Supabase CLI
supabase db reset
supabase db push

# Ou aplicando manualmente
psql -h db.fpafzaxqvudzppabaqum.supabase.co -p 5432 -d postgres -U postgres -f migrations/001_initial_schema.sql
psql -h db.fpafzaxqvudzppabaqum.supabase.co -p 5432 -d postgres -U postgres -f migrations/002_auth_functions.sql
```

### 2. Inserir Dados Iniciais
```bash
psql -h db.fpafzaxqvudzppabaqum.supabase.co -p 5432 -d postgres -U postgres -f seed.sql
```

### 3. Configurar Variáveis de Ambiente
```env
VITE_SUPABASE_URL=https://fpafzaxqvudzppabaqum.supabase.co
VITE_SUPABASE_ANON_KEY=sua_chave_anonima_aqui
```

## 📊 Dados de Exemplo

O arquivo `seed.sql` inclui:
- **5 Players** de exemplo com diferentes status
- **5 Arquivos de mídia** (vídeos, imagens, áudio)
- **3 Playlists** com itens organizados
- **3 Agendamentos** para diferentes horários
- **Logs de atividade** dos últimos 24 horas
- **Configurações do sistema**

## 🔧 Funções Principais

### Gestão de Players
- `update_player_status()` - Atualiza status do player
- `get_player_dashboard()` - Estatísticas do dashboard

### Gestão de Mídia
- `upload_media_file()` - Upload de arquivos com logging

### Auditoria
- Triggers automáticos para logging de mudanças
- Logs de atividade do usuário
- Histórico de alterações

## 📈 Views Disponíveis

- **`player_status_overview`** - Visão geral dos players
- **`recent_activity`** - Atividades recentes
- **`system_statistics`** - Estatísticas do sistema

## 🔒 Políticas de Segurança

### Usuários
- ✅ Ver próprio perfil
- ✅ Editar próprio perfil
- ✅ Admins podem gerenciar todos os usuários

### Players
- ✅ Usuários autenticados podem visualizar
- ✅ Apenas admins podem gerenciar

### Mídia
- ✅ Usuários autenticados podem visualizar
- ✅ Usuários podem fazer upload
- ✅ Usuários podem editar próprios arquivos
- ✅ Admins podem gerenciar todos

### Sistema
- ✅ Configurações públicas visíveis para todos
- ✅ Apenas admins podem modificar configurações

## 🚨 Importante

1. **Backup**: Sempre faça backup antes de aplicar migrações em produção
2. **Testes**: Teste todas as funções em ambiente de desenvolvimento
3. **RLS**: As políticas RLS são restritivas por segurança
4. **Logs**: Todas as ações são logadas para auditoria
5. **Performance**: Índices foram criados para otimizar consultas

## 📞 Suporte

Para dúvidas sobre o schema ou migrações, consulte:
- [Documentação do Supabase](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
