-- ============================================
-- V2 - Add Admin User
-- ============================================

-------------------------------------------------------
-- INSERT ADMIN USER
-------------------------------------------------------
-- Password: 123 (BCrypt hashed)
INSERT INTO users (id, nome, email, password_hash, ativo, data_admissao, data_saida)
VALUES (
    gen_random_uuid(),
    'Administrator',
    'admin@vacations.com',
    '$2a$10$rBV2PJjH8/IqU7tVH8L5wOxMXhVZRkGEzKvVqFVqKpU4KqGdN7fWy',
    TRUE,
    CURRENT_DATE,
    NULL
);

-------------------------------------------------------
-- ASSIGN ADMIN PROFILE TO ADMIN USER
-------------------------------------------------------
INSERT INTO user_profile (id, id_user, id_profile)
SELECT 
    gen_random_uuid(),
    u.id,
    p.id
FROM users u
CROSS JOIN profile p
WHERE u.email = 'admin@vacations.com'
AND p.nome = 'ADMIN';

-------------------------------------------------------
-- FIM DO SCRIPT
-------------------------------------------------------
