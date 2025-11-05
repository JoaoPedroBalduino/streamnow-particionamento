-- ============================================
-- StreamNow - Criação de Tabelas Particionadas
-- ============================================

-- Remover tabelas se existirem
DROP TABLE IF EXISTS reproducoes CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- ============================================
-- TABELA: usuarios
-- Particionamento: RANGE por data_cadastro
-- ============================================

CREATE TABLE usuarios (
    id_usuario SERIAL,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    data_cadastro DATE NOT NULL,
    plano VARCHAR(20) NOT NULL CHECK (plano IN ('Free', 'Premium', 'Family')),
    PRIMARY KEY (id_usuario, data_cadastro)
) PARTITION BY RANGE (data_cadastro);

-- Comentários explicativos
COMMENT ON TABLE usuarios IS 'Tabela particionada de usuários por data de cadastro';
COMMENT ON COLUMN usuarios.data_cadastro IS 'Coluna de particionamento - permite queries otimizadas por período';

-- ============================================
-- TABELA: reproducoes
-- Particionamento: RANGE por data_reproducao
-- ============================================

CREATE TABLE reproducoes (
    id_reproducao SERIAL,
    id_usuario INT NOT NULL,
    data_reproducao DATE NOT NULL,
    duracao_segundos INT NOT NULL CHECK (duracao_segundos > 0),
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_reproducao, data_reproducao)
) PARTITION BY RANGE (data_reproducao);

-- Comentários explicativos
COMMENT ON TABLE reproducoes IS 'Tabela particionada de reproduções por data - otimizada para alto volume';
COMMENT ON COLUMN reproducoes.data_reproducao IS 'Coluna de particionamento - facilita consultas temporais e arquivamento';

-- ============================================
-- Exibir estrutura das tabelas
-- ============================================

\d+ usuarios
\d+ reproducoes

SELECT 
    n.nspname as schema_name,
    c.relname as table_name,
    a.attname as column_name,
    t.typname as data_type,
    a.attnum as column_position
FROM pg_catalog.pg_attribute a
JOIN pg_catalog.pg_class c ON a.attrelid = c.oid
JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
JOIN pg_catalog.pg_type t ON a.atttypid = t.oid
WHERE c.relname IN ('usuarios', 'reproducoes')
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY c.relname, a.attnum;