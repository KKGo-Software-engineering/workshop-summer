PHONY: upload
upload:
	@echo "Uploading images..."
	curl -X POST http://localhost:8080/api/v1/upload \
	-H "Content-Type: multipart/form-data" \
	-F "images=@e-slip1.png" \
	-F "images=@e-slip2.png"

.PHONY: run
run:
	@echo "Running the server..."
	go run main.go