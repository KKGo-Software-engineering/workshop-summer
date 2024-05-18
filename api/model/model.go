package model

import "time"

type Transaction struct {
	ID              int64     `json:"id"`
	Date            time.Time `json:"date"`
	Amount          float64   `json:"amount"`
	Category        string    `json:"category"`
	TransactionType string    `json:"transaction_type"`
	Note            string    `json:"note,omitempty"`
	ImageURL        string    `json:"image_url,omitempty"`
	SpenderId       string    `json:"spender_id,omitempty"`
}
