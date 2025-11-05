-- ============================================
-- StreamNow - Consultas de Análise
-- ============================================

-- ============================================
-- CONSULTAS: Usuários
-- ============================================

-- 1. Total de usuários por país
SELECT 
    pais,
    COUNT(*) as total_usuarios,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentual
FROM usuarios
GROUP BY pais
ORDER BY total_usuarios DESC;

-- 2. Crescimento de cadastros por mês e ano
SELECT 
    EXTRACT(YEAR FROM data_cadastro) as ano,
    EXTRACT(MONTH FROM data_cadastro) as mes,
    TO_CHAR(data_cadastro, 'Month YYYY') as periodo,
    COUNT(*) as novos_cadastros
FROM usuarios
GROUP BY 
    EXTRACT(YEAR FROM data_cadastro),
    EXTRACT(MONTH FROM data_cadastro),
    TO_CHAR(data_cadastro, 'Month YYYY')
ORDER BY ano, mes;

-- 3. Distribuição de usuários por tipo de plano
SELECT 
    plano,
    COUNT(*) as total_usuarios,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentual
FROM usuarios
GROUP BY plano
ORDER BY total_usuarios DESC;

-- 4. Usuários cadastrados em um período específico (2025)
-- Esta query demonstra o partition pruning - apenas usuarios_2025 será consultada
EXPLAIN ANALYZE
SELECT 
    COUNT(*) as total_usuarios_2025,
    COUNT(DISTINCT pais) as paises_diferentes
FROM usuarios
WHERE data_cadastro >= '2025-01-01' 
  AND data_cadastro < '2026-01-01';

-- 5. Top 5 países com mais usuários Premium
SELECT 
    pais,
    COUNT(*) as usuarios_premium
FROM usuarios
WHERE plano = 'Premium'
GROUP BY pais
ORDER BY usuarios_premium DESC
LIMIT 5;

-- ============================================
-- CONSULTAS: Reproduções
-- ============================================

-- 6. Total de reproduções por categoria
SELECT 
    categoria,
    COUNT(*) as total_reproducoes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentual
FROM reproducoes
GROUP BY categoria
ORDER BY total_reproducoes DESC;

-- 7. Total de horas assistidas por categoria
SELECT 
    categoria,
    COUNT(*) as total_reproducoes,
    ROUND(SUM(duracao_segundos) / 3600.0, 2) as horas_totais,
    ROUND(AVG(duracao_segundos) / 60.0, 2) as duracao_media_minutos
FROM reproducoes
GROUP BY categoria
ORDER BY horas_totais DESC;

-- 8. Reproduções por período (mês a mês)
SELECT 
    EXTRACT(YEAR FROM data_reproducao) as ano,
    EXTRACT(MONTH FROM data_reproducao) as mes,
    TO_CHAR(data_reproducao, 'Month YYYY') as periodo,
    COUNT(*) as total_reproducoes,
    ROUND(SUM(duracao_segundos) / 3600.0, 2) as horas_assistidas
FROM reproducoes
GROUP BY 
    EXTRACT(YEAR FROM data_reproducao),
    EXTRACT(MONTH FROM data_reproducao),
    TO_CHAR(data_reproducao, 'Month YYYY')
ORDER BY ano, mes;

-- 9. Análise de Q4 2024 - Demonstra partition pruning
-- Apenas a partição reproducoes_2024_q4 será consultada
EXPLAIN ANALYZE
SELECT 
    categoria,
    COUNT(*) as reproducoes,
    ROUND(SUM(duracao_segundos) / 3600.0, 2) as horas_totais
FROM reproducoes
WHERE data_reproducao >= '2024-10-01' 
  AND data_reproducao < '2025-01-01'
GROUP BY categoria
ORDER BY horas_totais DESC;

-- 10. Top 5 categorias mais assistidas em 2025
SELECT 
    categoria,
    COUNT(*) as total_reproducoes,
    ROUND(SUM(duracao_segundos) / 3600.0, 2) as horas_totais
FROM reproducoes
WHERE data_reproducao >= '2025-01-01'
GROUP BY categoria
ORDER BY horas_totais DESC
LIMIT 5;

-- ============================================
-- CONSULTAS: Análises Combinadas
-- ============================================

-- 11. Usuários mais ativos (com mais reproduções)
SELECT 
    u.id_usuario,
    u.nome,
    u.pais,
    u.plano,
    COUNT(r.id_reproducao) as total_reproducoes,
    ROUND(SUM(r.duracao_segundos) / 3600.0, 2) as horas_assistidas
FROM usuarios u
INNER JOIN reproducoes r ON u.id_usuario = r.id_usuario
GROUP BY u.id_usuario, u.nome, u.pais, u.plano
ORDER BY horas_assistidas DESC
LIMIT 10;

-- 12. Média de horas assistidas por tipo de plano
SELECT 
    u.plano,
    COUNT(DISTINCT u.id_usuario) as total_usuarios,
    COUNT(r.id_reproducao) as total_reproducoes,
    ROUND(AVG(r.duracao_segundos) / 60.0, 2) as duracao_media_minutos,
    ROUND(SUM(r.duracao_segundos) / 3600.0, 2) as horas_totais
FROM usuarios u
LEFT JOIN reproducoes r ON u.id_usuario = r.id_usuario
GROUP BY u.plano
ORDER BY horas_totais DESC;

-- 13. Conteúdo mais popular por país
SELECT 
    u.pais,
    r.categoria,
    COUNT(*) as total_reproducoes,
    ROUND(SUM(r.duracao_segundos) / 3600.0, 2) as horas_totais
FROM usuarios u
INNER JOIN reproducoes r ON u.id_usuario = r.id_usuario
GROUP BY u.pais, r.categoria
ORDER BY u.pais, horas_totais DESC;

-- ============================================
-- ANÁLISE DE PERFORMANCE
-- ============================================

-- 14. Verificar tamanho das partições
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as tamanho_total,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as tamanho_tabela,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - 
                   pg_relation_size(schemaname||'.'||tablename)) as tamanho_indices
FROM pg_tables
WHERE tablename LIKE 'usuarios%' OR tablename LIKE 'reproducoes%'
ORDER BY tablename;

