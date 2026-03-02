CREATE TABLE IF NOT EXISTS user_email_confirmations (
    confirmation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID         NOT NULL REFERENCES users (user_id) ON DELETE CASCADE,
    token           VARCHAR(512) NOT NULL,
    expires_at      TIMESTAMP    NOT NULL,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    confirmed_at    TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_user_email_confirmations_user_id ON user_email_confirmations (user_id);
