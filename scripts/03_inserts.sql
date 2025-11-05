-- ============================================
-- StreamNow - Inserção de Dados de Teste
-- ============================================

-- ============================================
-- INSERÇÕES: usuarios
-- ============================================

-- Usuários cadastrados em 2024 (partição usuarios_2024)
INSERT INTO usuarios (nome, pais, data_cadastro, plano) VALUES
('João Silva', 'Brasil', '2024-03-15', 'Premium'),
('Maria Santos', 'Brasil', '2024-05-20', 'Family'),
('Pedro Oliveira', 'Portugal', '2024-07-10', 'Free'),
('Ana Costa', 'Brasil', '2024-09-05', 'Premium'),
('Carlos Mendes', 'Angola', '2024-11-22', 'Free'),
('Lucia Fernandes', 'Portugal', '2024-12-01', 'Family');

-- Usuários cadastrados em 2025 (partição usuarios_2025)
INSERT INTO usuarios (nome, pais, data_cadastro, plano) VALUES
('Roberto Alves', 'Brasil', '2025-01-10', 'Premium'),
('Patricia Lima', 'Moçambique', '2025-02-14', 'Free'),
('Fernando Rocha', 'Portugal', '2025-03-08', 'Family'),
('Juliana Martins', 'Brasil', '2025-03-25', 'Premium'),
('Ricardo Souza', 'Brasil', '2025-10-15', 'Free'),
('Camila Pereira', 'Angola', '2025-11-01', 'Premium');

-- ============================================
-- INSERÇÕES: reproducoes
-- ============================================

-- Reproduções em Q4 2024 (partição reproducoes_2024_q4)
INSERT INTO reproducoes (id_usuario, data_reproducao, duracao_segundos, categoria) VALUES
-- Outubro 2024
(1, '2024-10-05', 7200, 'Filme'),
(2, '2024-10-12', 2400, 'Série'),
(3, '2024-10-20', 5400, 'Documentário'),
(4, '2024-10-25', 3600, 'Filme'),

-- Novembro 2024
(5, '2024-11-03', 1800, 'Infantil'),
(1, '2024-11-15', 4500, 'Série'),
(6, '2024-11-20', 6300, 'Filme'),
(2, '2024-11-28', 2700, 'Documentário'),

-- Dezembro 2024
(3, '2024-12-05', 5100, 'Filme'),
(4, '2024-12-10', 3200, 'Série'),
(5, '2024-12-18', 2100, 'Infantil'),
(6, '2024-12-25', 7800, 'Filme');

-- Reproduções em Q1 2025 (partição reproducoes_2025_q1)
INSERT INTO reproducoes (id_usuario, data_reproducao, duracao_segundos, categoria) VALUES
-- Janeiro 2025
(7, '2025-01-15', 4800, 'Filme'),
(8, '2025-01-20', 2600, 'Série'),
(9, '2025-01-25', 5600, 'Documentário'),
(10, '2025-01-30', 3400, 'Filme'),

-- Fevereiro 2025
(7, '2025-02-05', 1900, 'Infantil'),
(8, '2025-02-14', 4200, 'Filme'),
(9, '2025-02-20', 3800, 'Série'),
(10, '2025-02-28', 6100, 'Documentário'),

-- Março 2025
(7, '2025-03-10', 5400, 'Filme'),
(8, '2025-03-15', 2800, 'Série'),
(9, '2025-03-22', 7200, 'Filme'),
(10, '2025-03-30', 3100, 'Documentário');

-- ============================================
-- Verificar dados inseridos
-- ============================================

-- Contar usuários por partição
SELECT 'usuarios_2024' as particao, COUNT(*) as total FROM usuarios_2024
UNION ALL
SELECT 'usuarios_2025' as particao, COUNT(*) as total FROM usuarios_2025
ORDER BY particao;

-- Contar reproduções por partição
SELECT 'reproducoes_2024_q4' as particao, COUNT(*) as total FROM reproducoes_2024_q4
UNION ALL
SELECT 'reproducoes_2025_q1' as particao, COUNT(*) as total FROM reproducoes_2025_q1
ORDER BY particao;

-- Verificar distribuição de usuários por país
SELECT pais, COUNT(*) as total_usuarios
FROM usuarios
GROUP BY pais
ORDER BY total_usuarios DESC;

-- Verificar distribuição de reproduções por categoria
SELECT categoria, COUNT(*) as total_reproducoes
FROM reproducoes
GROUP BY categoria
ORDER BY total_reproducoes DESC;