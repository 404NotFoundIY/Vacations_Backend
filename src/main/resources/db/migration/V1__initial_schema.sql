-- ============================================
-- V1 - Modelo de Férias com UUID
-- ============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-------------------------------------------------------
-- PROFILE
-------------------------------------------------------

CREATE TABLE profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO profile (nome) VALUES ('ADMIN'), ('RH'), ('TL'), ('USER');

-------------------------------------------------------
-- USERS
-------------------------------------------------------

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_admissao DATE NOT NULL,
    data_saida DATE NULL
);

-------------------------------------------------------
-- USER_PROFILE
-------------------------------------------------------

CREATE TABLE user_profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_user UUID NOT NULL,
    id_profile UUID NOT NULL,

    CONSTRAINT fk_user_profile_user FOREIGN KEY (id_user)
        REFERENCES users (id),

    CONSTRAINT fk_user_profile_profile FOREIGN KEY (id_profile)
        REFERENCES profile (id)
);

CREATE INDEX idx_user_profile_user ON user_profile (id_user);
CREATE INDEX idx_user_profile_profile ON user_profile (id_profile);

-------------------------------------------------------
-- USER_MANAGER
-------------------------------------------------------

CREATE TABLE user_manager (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_user UUID NOT NULL,
    id_manager UUID NOT NULL,
    tipo_hierarquia VARCHAR(50) NOT NULL,

    CONSTRAINT fk_user_manager_user FOREIGN KEY (id_user)
        REFERENCES users (id),

    CONSTRAINT fk_user_manager_manager FOREIGN KEY (id_manager)
        REFERENCES users (id)
);

CREATE INDEX idx_user_manager_user ON user_manager (id_user);
CREATE INDEX idx_user_manager_manager ON user_manager (id_manager);

-------------------------------------------------------
-- TYPE
-------------------------------------------------------

CREATE TABLE type (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descricao VARCHAR(100) NOT NULL
);

INSERT INTO type (descricao) VALUES 
('Férias'),
('Baixa médica'),
('Falta justificada'),
('Folga'),
('Outro');

-------------------------------------------------------
-- PERIOD
-------------------------------------------------------

CREATE TABLE period (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descricao VARCHAR(100) NOT NULL
);

INSERT INTO period (descricao) VALUES 
('Dia inteiro'),
('Manhã'),
('Tarde');

-------------------------------------------------------
-- VACATION_REQUEST
-------------------------------------------------------

CREATE TABLE vacation_request (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_user UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type_id UUID NOT NULL,
    period_id UUID NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_vacreq_user FOREIGN KEY (id_user)
        REFERENCES users (id),

    CONSTRAINT fk_vacreq_type FOREIGN KEY (type_id)
        REFERENCES type (id),

    CONSTRAINT fk_vacreq_period FOREIGN KEY (period_id)
        REFERENCES period (id)
);

CREATE INDEX idx_vacreq_user ON vacation_request (id_user);
CREATE INDEX idx_vacreq_status ON vacation_request (status);

-------------------------------------------------------
-- VACATION_APPROVAL
-------------------------------------------------------

CREATE TABLE vacation_approval (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    approver_id UUID NOT NULL,
    role VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,
    justification TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_vacapproval_request FOREIGN KEY (request_id)
        REFERENCES vacation_request (id),

    CONSTRAINT fk_vacapproval_approver FOREIGN KEY (approver_id)
        REFERENCES users (id)
);

CREATE INDEX idx_vacapproval_request ON vacation_approval (request_id);
CREATE INDEX idx_vacapproval_approver ON vacation_approval (approver_id);

-------------------------------------------------------
-- VACATION_BALANCE
-------------------------------------------------------

CREATE TABLE vacation_balance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_user UUID NOT NULL,
    ano INT NOT NULL,
    dias_totais DECIMAL(5,2) NOT NULL,
    dias_usados DECIMAL(5,2) NOT NULL DEFAULT 0,
    dias_transitados DECIMAL(5,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_vacbalance_user FOREIGN KEY (id_user)
        REFERENCES users (id)
);

CREATE INDEX idx_vacbalance_user ON vacation_balance (id_user);
CREATE INDEX idx_vacbalance_ano ON vacation_balance (ano);

-------------------------------------------------------
-- FIM DO SCRIPT
-------------------------------------------------------
