PHONY: setup-pre-commit
setup-pre-commit:
	@echo "Setting up pre-commit..."
	./scripts/setup-pre-commit.sh

PHONY: test
test:
	@echo "Running tests..."
	go test -v ./...

PHONY: test-it
test-it:
	@echo "Running integration tests..."
	go test -v -run "Test.*IT" -tags=integration ./...

PHONY: test-it-docker
test-it-docker:
	docker-compose -f docker-compose.it.test.yaml down && \
	docker-compose -f docker-compose.it.test.yaml up --build --force-recreate --abort-on-container-exit --exit-code-from it_tests

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

.PHONY: slow
slow:
	@echo "Running the server with slow response..."
	curl http://localhost:8080/api/v1/slow

.PHONY: health
health:
	@echo "Checking the health of the server..."
	curl http://localhost:8080/api/v1/health

.PHONY: spenders
spenders:
	@echo "Getting the spenders..."
	curl -u user:secret http://localhost:8080/api/v1/spenders
