package transaction

type Transaction struct {
	ID              string `json:"id"`
	Date            string `json:"date"`
	Amount          int    `json:"amount"`
	Category        string `json:"category"`
	TransactionType string `json:"transaction_type"`
	SpenderID       int    `json:"spender_id"`
	Note            string `json:"note"`
	ImageURL        string `json:"image_url"`
}
