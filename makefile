PHONY: upload
upload:
	@echo "Uploading to $(DEVICE)"
	curl -X POST http://localhost:8080/api/v1/upload \
  -F "images=@e-slip1.png" \
  -F "images=@e-slip2.png"