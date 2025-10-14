# 🚀 DEPLOY NO VERCEL - PASSO A PASSO

## 📋 Pré-requisitos
- ✅ Conta no GitHub (gratuita)
- ✅ Conta no Vercel (gratuita)
- ✅ Projeto funcionando localmente

---

## 🔥 PASSO 1: Subir código para GitHub

### 1.1 Criar repositório no GitHub
1. **Acesse**: https://github.com
2. **Clique em "New repository"**
3. **Nome**: `chargeads-system`
4. **Deixe "Public"** (gratuito)
5. **Clique "Create repository"**

### 1.2 Subir código (Terminal/PowerShell)
```bash
# Na pasta do seu projeto
git init
git add .
git commit -m "Primeiro commit - ChargeADS System"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/chargeads-system.git
git push -u origin main
```

---

## 🚀 PASSO 2: Deploy no Vercel

### 2.1 Criar conta no Vercel
1. **Acesse**: https://vercel.com
2. **Clique "Sign Up"**
3. **Escolha "Continue with GitHub"**
4. **Autorize** o Vercel a acessar seus repositórios

### 2.2 Importar projeto
1. **Clique "New Project"**
2. **Selecione** seu repositório `chargeads-system`
3. **Clique "Import"**

### 2.3 Configurar projeto
- **Framework Preset**: Vite
- **Root Directory**: `./` (padrão)
- **Build Command**: `npm run build`
- **Output Directory**: `dist`
- **Install Command**: `npm install`

### 2.4 Adicionar variáveis de ambiente
1. **Clique "Environment Variables"**
2. **Adicione**:
   - `VITE_SUPABASE_URL` = sua URL do Supabase
   - `VITE_SUPABASE_ANON_KEY` = sua chave anônima

### 2.5 Deploy
1. **Clique "Deploy"**
2. **Aguarde** 2-3 minutos
3. **Seu site estará online!** 🎉

---

## 🔧 PASSO 3: Configurar Supabase

### 3.1 Atualizar URLs permitidas
1. **Supabase Dashboard** → **Authentication** → **Settings**
2. **Site URL**: `https://seu-projeto.vercel.app`
3. **Redirect URLs**: 
   - `https://seu-projeto.vercel.app/login`
   - `https://seu-projeto.vercel.app/dashboard`
4. **Save**

---

## ✅ PASSO 4: Testar

### 4.1 Acesse seu site
- **URL**: `https://seu-projeto.vercel.app`
- **Teste login**
- **Teste criação de usuário**
- **Verifique** se tudo funciona

### 4.2 Teste em outros dispositivos
- **Celular**
- **Tablet**
- **Outros computadores**
- **Compartilhe** o link com outros

---

## 🎯 RESULTADO FINAL

### ✅ Você terá:
- **Site online** 24/7
- **HTTPS automático**
- **Domínio bonito**: `chargeads-system.vercel.app`
- **Deploy automático** a cada push no GitHub
- **Performance excelente**

### 🔄 Deploy automático:
- **Faça alterações** no código
- **Commit e push** para GitHub
- **Vercel faz deploy** automaticamente
- **Site atualizado** em 2 minutos!

---

## 🆘 Problemas Comuns

### ❌ Build falha:
- **Verifique** se todas as dependências estão no `package.json`
- **Teste** `npm run build` localmente primeiro

### ❌ Erro de autenticação:
- **Verifique** as variáveis de ambiente no Vercel
- **Atualize** URLs no Supabase

### ❌ Site não carrega:
- **Aguarde** alguns minutos (primeiro deploy demora mais)
- **Verifique** os logs no Vercel Dashboard

---

## 🎉 PRONTO!

**Seu site ChargeADS estará online e acessível de qualquer lugar!**

**Quer ajuda com algum passo específico?** 🤖
