-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS "transaction" (
  id SERIAL PRIMARY KEY,
  date TIMESTAMP WITH TIME ZONE,
  amount DECIMAL(10,2) DEFAULT 0,
  category VARCHAR(50) DEFAULT '',
  transaction_type VARCHAR(20) DEFAULT '',
  note VARCHAR(255) DEFAULT '',
  image_url VARCHAR(255) DEFAULT '',
  spender_id INT
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS "transaction";
-- +goose StatementEnd
