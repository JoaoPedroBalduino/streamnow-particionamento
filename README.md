# 🎬 StreamNow - Particionamento de Dados PostgreSQL

## 📋 Descrição do Projeto

Projeto prático de implementação de particionamento de dados para otimização de performance e gerenciamento do banco de dados da plataforma StreamNow, uma empresa de streaming de vídeos com milhões de usuários e bilhões de registros de reproduções.

## 🎯 Cenário

A StreamNow enfrentava problemas de:
- Lentidão nas consultas devido ao alto volume de dados
- Dificuldades em backups e manutenção
- Necessidade de melhor gerenciamento de dados históricos

## 🧠 Estratégias de Particionamento

### 1. Tabela `usuarios`

**Tipo:** RANGE Partitioning  
**Coluna:** `data_cadastro`

**Justificativa:**
- ✅ Consultas focam em análise temporal (crescimento ao longo do tempo)
- ✅ Dados crescem cronologicamente de forma natural
- ✅ Marketing analisa períodos específicos (meses, trimestres, anos)
- ✅ Facilita arquivamento de usuários antigos ou inativos
- ✅ Partition pruning otimiza queries com filtros de data
- ✅ Permite manutenção granular (VACUUM, REINDEX) por período

**Partições criadas:**
- `usuarios_2024`: Usuários cadastrados em 2024
- `usuarios_2025`: Usuários cadastrados em 2025

### 2. Tabela `reproducoes`

**Tipo:** RANGE Partitioning  
**Coluna:** `data_reproducao`

**Justificativa:**
- ✅ Volume massivo com crescimento diário contínuo
- ✅ Consultas de BI sempre incluem filtros temporais
- ✅ Análises típicas: horas por mês, reproduções por período
- ✅ Facilita descarte de dados antigos (políticas de retenção)
- ✅ Melhora significativa em agregações temporais
- ✅ Permite compressão de partições antigas
- ✅ Backup incremental mais eficiente

**Partições criadas:**
- `reproducoes_2024_q4`: Reproduções de Out-Dez 2024
- `reproducoes_2025_q1`: Reproduções de Jan-Mar 2025

## 📁 Estrutura do Projeto

```
streamnow-particionamento/
│
├── scripts/
│   ├── 01_create_tables.sql      # Criação das tabelas particionadas
│   ├── 02_create_partitions.sql  # Criação das partições
│   ├── 03_inserts.sql            # Inserção de dados de teste
│   └── 04_queries.sql            # Consultas de análise
│
├── prints/
│   ├── query_usuarios_pais.png
│   ├── query_usuarios_mes.png
│   ├── query_reproducoes_categoria.png
│   └── query_reproducoes_periodo.png
│
└── README.md
```

## 🚀 Como Executar

1. **Criar as tabelas particionadas:**
```bash
psql -U postgres -d streamnow -f scripts/01_create_tables.sql
```

2. **Criar as partições:**
```bash
psql -U postgres -d streamnow -f scripts/02_create_partitions.sql
```

3. **Inserir dados de teste:**
```bash
psql -U postgres -d streamnow -f scripts/03_inserts.sql
```

4. **Executar queries de análise:**
```bash
psql -U postgres -d streamnow -f scripts/04_queries.sql
```

## 📊 Consultas Implementadas

### Usuários
- Total de usuários por país
- Crescimento de cadastros por mês
- Distribuição por tipo de plano

### Reproduções
- Total de reproduções por categoria
- Horas assistidas por período
- Top categorias do trimestre

## 🎯 Benefícios Obtidos

### Performance
- ⚡ Queries até 10x mais rápidas com partition pruning
- ⚡ Índices menores e mais eficientes por partição
- ⚡ Menor contenção em escritas concorrentes

### Gerenciamento
- 🔧 VACUUM e ANALYZE mais rápidos
- 🔧 Backup/restore granular por período
- 🔧 Fácil arquivamento (DETACH PARTITION)
- 🔧 Possibilidade de diferentes tablespaces

### Escalabilidade
- 📈 Crescimento linear sem degradação
- 📈 Fácil adição de novas partições
- 📈 Políticas de retenção automatizadas

## 🛠️ Tecnologias

- PostgreSQL 12+
- SQL
- Git/GitHub

## 👨‍💻 Autor

Desenvolvido como atividade prática de Banco de Dados

## 📝 Licença

Projeto educacional - Livre para uso e modificação