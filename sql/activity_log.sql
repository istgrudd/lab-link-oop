-- ============================================
-- LABLINK - Activity Log Table
-- Run this SQL in your MySQL database
-- ============================================

CREATE TABLE IF NOT EXISTS tb_activity_log (
    log_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    action VARCHAR(20) NOT NULL,           -- CREATE, UPDATE, DELETE
    target_type VARCHAR(50) NOT NULL,      -- PROJECT, MEMBER, EVENT, AUTH
    target_id VARCHAR(50),                 -- ID of affected item
    target_name VARCHAR(200),              -- Name of affected item
    description TEXT,                      -- Detailed description
    ip_address VARCHAR(50),                -- For security audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_target_type (target_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample data untuk testing (opsional)
-- INSERT INTO tb_activity_log (log_id, user_id, user_name, action, target_type, target_id, target_name, description)
-- VALUES ('LOG-001', 'U001', 'Admin', 'CREATE', 'PROJECT', 'P001', 'Riset AI', 'Membuat proyek baru');
