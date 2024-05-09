-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS "spender" (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS "spender";
-- +goose StatementEnd
