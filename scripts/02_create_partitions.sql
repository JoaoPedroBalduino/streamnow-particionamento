-- ============================================
-- StreamNow - Criação de Partições
-- ============================================

-- ============================================
-- PARTIÇÕES: usuarios
-- ============================================

-- Partição para usuários cadastrados em 2024
CREATE TABLE usuarios_2024 PARTITION OF usuarios
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partição para usuários cadastrados em 2025
CREATE TABLE usuarios_2025 PARTITION OF usuarios
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Criar índices nas partições para otimizar consultas
CREATE INDEX idx_usuarios_2024_pais ON usuarios_2024(pais);
CREATE INDEX idx_usuarios_2024_plano ON usuarios_2024(plano);
CREATE INDEX idx_usuarios_2024_data ON usuarios_2024(data_cadastro);

CREATE INDEX idx_usuarios_2025_pais ON usuarios_2025(pais);
CREATE INDEX idx_usuarios_2025_plano ON usuarios_2025(plano);
CREATE INDEX idx_usuarios_2025_data ON usuarios_2025(data_cadastro);

-- ============================================
-- PARTIÇÕES: reproducoes
-- ============================================

-- Partição para Q4 2024 (Outubro a Dezembro)
CREATE TABLE reproducoes_2024_q4 PARTITION OF reproducoes
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Partição para Q1 2025 (Janeiro a Março)
CREATE TABLE reproducoes_2025_q1 PARTITION OF reproducoes
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

-- Criar índices nas partições para otimizar consultas
CREATE INDEX idx_reproducoes_2024_q4_usuario ON reproducoes_2024_q4(id_usuario);
CREATE INDEX idx_reproducoes_2024_q4_categoria ON reproducoes_2024_q4(categoria);
CREATE INDEX idx_reproducoes_2024_q4_data ON reproducoes_2024_q4(data_reproducao);

CREATE INDEX idx_reproducoes_2025_q1_usuario ON reproducoes_2025_q1(id_usuario);
CREATE INDEX idx_reproducoes_2025_q1_categoria ON reproducoes_2025_q1(categoria);
CREATE INDEX idx_reproducoes_2025_q1_data ON reproducoes_2025_q1(data_reproducao);

-- ============================================
-- Verificar partições criadas
-- ============================================

-- Listar todas as partições de usuarios
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE tablename LIKE 'usuarios%'
ORDER BY tablename;

-- Listar todas as partições de reproducoes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE tablename LIKE 'reproducoes%'
ORDER BY tablename;

-- Verificar definição das partições
SELECT 
    nmsp_parent.nspname AS parent_schema,
    parent.relname AS parent_table,
    nmsp_child.nspname AS child_schema,
    child.relname AS child_table,
    pg_get_expr(child.relpartbound, child.oid) AS partition_expression
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child ON pg_inherits.inhrelid = child.oid
JOIN pg_namespace nmsp_parent ON parent.relnamespace = nmsp_parent.oid
JOIN pg_namespace nmsp_child ON child.relnamespace = nmsp_child.oid
WHERE parent.relname IN ('usuarios', 'reproducoes')
ORDER BY parent.relname, child.relname;