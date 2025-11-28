-- ============================================
-- V3 - Fix Admin Password Hash
-- ============================================

-------------------------------------------------------
-- UPDATE ADMIN PASSWORD TO CORRECT HASH FOR "123"
-------------------------------------------------------
UPDATE users 
SET password_hash = '$2a$10$tgGGX7l.fqrol6o6jYFjnuKOEWYP7yKYvneEUtDeBEjUpDOPTijLK'
WHERE email = 'admin@vacations.com';

-------------------------------------------------------
-- FIM DO SCRIPT
-------------------------------------------------------
