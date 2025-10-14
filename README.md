# ChargeADS - Sistema de Gerenciamento

Sistema completo de gerenciamento de sinalização digital (Digital Signage) desenvolvido com Vue.js 3, Vite e Supabase.

## 🚀 Tecnologias

- **Frontend**: Vue.js 3 (Composition API)
- **Build Tool**: Vite
- **Database**: Supabase (PostgreSQL)
- **Autenticação**: Supabase Auth
- **Estado**: Pinia
- **Estilos**: SCSS + CSS Variables
- **Real-time**: Supabase Realtime

## 📋 Pré-requisitos

- Node.js 18+ 
- npm ou yarn
- Conta no Supabase (já configurada)

## 🔧 Instalação

1. **Clone o repositório:**
```bash
git clone <url-do-repositorio>
cd developerment
```

2. **Instale as dependências:**
```bash
npm install
```

3. **Configure as variáveis de ambiente:**

O arquivo `.env.local` já está configurado com as credenciais do Supabase.

## ▶️ Como Usar

### Desenvolvimento

```bash
npm run dev
```

Acesse: `http://localhost:3000` (ou a porta disponível)

### Build para Produção

```bash
npm run build
```

### Preview da Build

```bash
npm run preview
```

## 🔐 Credenciais de Acesso

### Usuário Admin
- **Email**: `admin@chargeads.com`
- **Senha**: `123456`
- **Permissões**: Administrador completo

## 📊 Funcionalidades

### ✅ Autenticação
- Login/Logout com Supabase Auth
- Recuperação de senha
- Registro de novos usuários
- Proteção de rotas
- Gestão de sessão

### ✅ Dashboard
- KPI Cards em tempo real
- Estatísticas de players
- Status online/offline/instável
- Uptime médio
- Auto-refresh (30s)

### ✅ Monitoramento
- **Indicadores**: Dashboard com métricas em tempo real
- **Monitores**: Gestão de dispositivos de sinalização
- **Programações**: Agendamento de conteúdo

### ✅ Gestão
- **Mídias**: Upload e gerenciamento de arquivos
- **Configurações**: Configurações do sistema

### ✅ Real-time
- Atualização automática de status
- WebSocket via Supabase Realtime
- Notificações de mudanças

## 🗄️ Banco de Dados

### Estrutura de Tabelas

- `users` - Usuários do sistema
- `user_profiles` - Perfis adicionais
- `players` - Dispositivos de sinalização
- `player_statistics` - Estatísticas de uptime
- `player_logs` - Histórico de eventos
- `media_files` - Arquivos de mídia
- `playlists` - Listas de reprodução
- `schedules` - Agendamentos
- `system_settings` - Configurações
- `audit_logs` - Auditoria

### Migrações

As migrações estão em `supabase/migrations/`:
- `001_initial_schema.sql` - Schema inicial
- `002_auth_functions.sql` - Funções de autenticação

### Dados de Exemplo

Execute o seed para popular o banco:
```sql
-- Ver arquivo: supabase/seed.sql
```

## 🔒 Segurança

- **RLS (Row Level Security)** ativado em todas as tabelas
- **Políticas de acesso** baseadas em roles (admin/user/viewer)
- **Auditoria completa** de ações dos usuários
- **JWT tokens** gerenciados pelo Supabase
- **Variáveis de ambiente** para credenciais sensíveis

## 📁 Estrutura do Projeto

```
developerment/
├── src/
│   ├── assets/
│   │   └── scss/          # Estilos globais
│   ├── components/        # Componentes Vue
│   ├── config/            # Configurações
│   ├── router/            # Vue Router
│   ├── stores/            # Pinia stores
│   └── views/             # Páginas
├── supabase/
│   ├── migrations/        # Migrações SQL
│   ├── config.toml        # Config Supabase
│   └── seed.sql           # Dados iniciais
├── index.html
├── vite.config.js
└── package.json
```

## 🎨 Design System

O sistema utiliza um design system completo baseado em variáveis CSS:

- **Cores**: Primary, Success, Warning, Danger, Info
- **Escala de cinza**: 50-900
- **Espaçamento**: Sistema de 4px (1-20)
- **Tipografia**: Inter font family
- **Sombras**: XS a XL
- **Bordas**: Radius de SM a Full
- **Transições**: Fast, Normal, Slow

## 📱 Responsividade

Sistema totalmente responsivo com breakpoints:
- **Mobile**: < 768px
- **Tablet**: 768px - 1023px
- **Desktop**: 1024px - 1439px
- **Large Desktop**: 1440px - 1919px
- **4K+**: > 1920px

## 🔄 Real-time Updates

O sistema usa Supabase Realtime para:
- Status de players em tempo real
- Logs de atividade instantâneos
- Notificações de mudanças
- Sincronização automática

## 📈 Performance

- **Code splitting** automático
- **Lazy loading** de rotas
- **Tree shaking** do Vite
- **Otimização de assets**
- **Cache inteligente**

## 🐛 Debug

### Logs do Vite
O servidor já está configurado para mostrar logs detalhados.

### Logs do Supabase
Use as funções de log no Supabase Dashboard.

### Network
Monitore as requisições no DevTools.

## 📝 Licença

Todos os direitos reservados © 2024 ChargeADS

## 👥 Suporte

Para dúvidas ou suporte:
- Email: suporte@chargeads.com
- Documentação: [Link para docs]

## 🔄 Changelog

### v1.0.0 (2024-12-19)
- ✅ Sistema inicial com Vue.js 3
- ✅ Integração com Supabase
- ✅ Dashboard com indicadores em tempo real
- ✅ Autenticação completa
- ✅ Gestão de players
- ✅ Real-time updates
- ✅ Design system responsivo
- ✅ RLS e auditoria

## 🚧 Roadmap

- [ ] Upload de mídia com drag & drop
- [ ] Editor de playlists visual
- [ ] Calendário de agendamentos
- [ ] Relatórios e analytics
- [ ] Notificações push
- [ ] Multi-tenancy
- [ ] PWA support
- [ ] Dark mode completo
