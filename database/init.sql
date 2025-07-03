-- Script to initialize the database schema for the Car Sales Website

-- Users table for administrators
CREATE TABLE IF NOT EXISTS AdminUsers (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Comment on AdminUsers table
COMMENT ON TABLE AdminUsers IS 'Tabela para armazenar os usuários administradores do sistema.';
COMMENT ON COLUMN AdminUsers.id IS 'Identificador único do usuário administrador.';
COMMENT ON COLUMN AdminUsers.usuario IS 'Nome de usuário para login (único).';
COMMENT ON COLUMN AdminUsers.senha_hash IS 'Hash da senha do usuário.';
COMMENT ON COLUMN AdminUsers.data_criacao IS 'Data e hora de criação do registro do usuário.';

-- Enum types for vehicle properties to ensure consistency
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_veiculo') THEN
        CREATE TYPE tipo_veiculo AS ENUM ('Novo', 'Seminovo');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_combustivel') THEN
        CREATE TYPE tipo_combustivel AS ENUM ('Gasolina', 'Álcool', 'Flex', 'Diesel', 'Elétrico', 'Híbrido');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_cambio') THEN
        CREATE TYPE tipo_cambio AS ENUM ('Manual', 'Automático');
    END IF;
END$$;

-- Vehicles table
CREATE TABLE IF NOT EXISTS Vehicles (
    id SERIAL PRIMARY KEY,
    tipo tipo_veiculo NOT NULL, -- 'Novo' ou 'Seminovo'
    marca VARCHAR(100) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    versao VARCHAR(100), -- Opcional, e.g., "1.0 LTZ Turbo"
    ano_fabricacao INT NOT NULL,
    ano_modelo INT NOT NULL,
    preco NUMERIC(10, 2) NOT NULL,
    quilometragem INT, -- Nulo para carros novos
    combustivel tipo_combustivel NOT NULL,
    cambio tipo_cambio NOT NULL,
    cor VARCHAR(50),
    portas INT, -- e.g., 2, 4
    placa VARCHAR(10) UNIQUE, -- Placa do veículo, se seminovo e aplicável
    descricao TEXT,
    recursos_opcionais TEXT[], -- Array de strings para opcionais e recursos
    imagens TEXT[], -- Array de URLs ou caminhos para as imagens
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    disponivel BOOLEAN DEFAULT TRUE -- Indica se o veículo está disponível para venda
);

-- Comments on Vehicles table
COMMENT ON TABLE Vehicles IS 'Tabela para armazenar informações sobre os veículos à venda.';
COMMENT ON COLUMN Vehicles.id IS 'Identificador único do veículo.';
COMMENT ON COLUMN Vehicles.tipo IS 'Tipo do veículo (Novo, Seminovo).';
COMMENT ON COLUMN Vehicles.marca IS 'Marca do veículo (e.g., Fiat, Chevrolet).';
COMMENT ON COLUMN Vehicles.modelo IS 'Modelo do veículo (e.g., Uno, Onix).';
COMMENT ON COLUMN Vehicles.versao IS 'Versão específica do modelo (e.g., 1.0 LTZ Turbo).';
COMMENT ON COLUMN Vehicles.ano_fabricacao IS 'Ano de fabricação do veículo.';
COMMENT ON COLUMN Vehicles.ano_modelo IS 'Ano do modelo do veículo.';
COMMENT ON COLUMN Vehicles.preco IS 'Preço de venda do veículo.';
COMMENT ON COLUMN Vehicles.quilometragem IS 'Quilometragem do veículo (para seminovos).';
COMMENT ON COLUMN Vehicles.combustivel IS 'Tipo de combustível do veículo.';
COMMENT ON COLUMN Vehicles.cambio IS 'Tipo de câmbio do veículo (Manual, Automático).';
COMMENT ON COLUMN Vehicles.cor IS 'Cor do veículo.';
COMMENT ON COLUMN Vehicles.portas IS 'Número de portas do veículo.';
COMMENT ON COLUMN Vehicles.placa IS 'Placa do veículo (para seminovos, se aplicável, e deve ser única).';
COMMENT ON COLUMN Vehicles.descricao IS 'Descrição detalhada do veículo.';
COMMENT ON COLUMN Vehicles.recursos_opcionais IS 'Lista de recursos e opcionais do veículo.';
COMMENT ON COLUMN Vehicles.imagens IS 'Lista de URLs ou caminhos das imagens do veículo.';
COMMENT ON COLUMN Vehicles.data_cadastro IS 'Data e hora de cadastro do veículo no sistema.';
COMMENT ON COLUMN Vehicles.disponivel IS 'Indica se o veículo está disponível para venda.';

-- Leads table for contact inquiries
CREATE TABLE IF NOT EXISTS Leads (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    mensagem TEXT,
    id_veiculo INT, -- Opcional, se o contato for sobre um veículo específico
    data_criacao TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Novo', -- e.g., Novo, Contatado, Convertido
    FOREIGN KEY (id_veiculo) REFERENCES Vehicles(id) ON DELETE SET NULL
);

-- Comments on Leads table
COMMENT ON TABLE Leads IS 'Tabela para armazenar os contatos (leads) gerados através do site.';
COMMENT ON COLUMN Leads.id IS 'Identificador único do lead.';
COMMENT ON COLUMN Leads.nome IS 'Nome da pessoa que entrou em contato.';
COMMENT ON COLUMN Leads.email IS 'E-mail da pessoa.';
COMMENT ON COLUMN Leads.telefone IS 'Telefone da pessoa.';
COMMENT ON COLUMN Leads.mensagem IS 'Mensagem enviada pela pessoa.';
COMMENT ON COLUMN Leads.id_veiculo IS 'ID do veículo de interesse (se aplicável).';
COMMENT ON COLUMN Leads.data_criacao IS 'Data e hora da criação do lead.';
COMMENT ON COLUMN Leads.status IS 'Status atual do lead no funil de vendas.';


-- Example: Insert a default admin user (replace with a secure password hashing mechanism in practice)
-- For demonstration, using a plain text password here which is NOT secure.
-- In a real application, this should be done via an admin creation script with proper hashing.
-- INSERT INTO AdminUsers (usuario, senha_hash) VALUES ('admin', 'senha_admin_plain_text')
-- ON CONFLICT (usuario) DO NOTHING;
-- COMMENT ON THIS LINE: The above insert is commented out. Admin user creation should be handled securely.

-- Indexes for frequently queried columns
CREATE INDEX IF NOT EXISTS idx_vehicles_marca ON Vehicles(marca);
CREATE INDEX IF NOT EXISTS idx_vehicles_modelo ON Vehicles(modelo);
CREATE INDEX IF NOT EXISTS idx_vehicles_preco ON Vehicles(preco);
CREATE INDEX IF NOT EXISTS idx_vehicles_ano_fabricacao ON Vehicles(ano_fabricacao);
CREATE INDEX IF NOT EXISTS idx_leads_id_veiculo ON Leads(id_veiculo);

-- Grant privileges to the database user if it's different from the owner
-- Example: GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_app_user;
-- This is usually handled by Docker PostgreSQL entrypoint if POSTGRES_USER is used for connection.

-- Print a message to confirm script execution (useful for logs)
\echo 'Database schema initialized successfully.'
