# Go summer workshop

- [Go summer workshop](#go-summer-workshop)
	- [Pre-requisites](#pre-requisites)
	- [Tools](#tools)
	- [Workshop URL](#workshop-url)
- [HongJot Diagram](#hongjot-diagram)
	- [Infrastructure](#infrastructure)
	- [Getting Started](#getting-started)
		- [Step 0: IaC (Infrastructure as Code) ✅](#step-0-iac-infrastructure-as-code-)
		- [Step 1: Fork the repository and setup Github Actions ✅](#step-1-fork-the-repository-and-setup-github-actions-)
		- [Step 2: Create ArgoCD application](#step-2-create-argocd-application)
	- [🏁 Development เริ่มยังไง?](#-development-เริ่มยังไง)
	- [👻 รัน Test ยังไง?](#-รัน-test-ยังไง)
		- [🪛 Unit](#-unit)
		- [⚙️ Integration](#️-integration)
	- [⚓ ใช้งาน pre-commit](#-ใช้งาน-pre-commit)
	- [🗃️ ใช้งาน database migration](#️-ใช้งาน-database-migration)

## Pre-requisites
- [Go version 1.21.9 or higher installed](https://go.dev/dl/)
- [Docker installed](https://docs.docker.com/get-docker/)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) - Never mind if you don't have it, we have
  done it for you

## Tools
- SonarQube - [https://sonarqube.werockstar.dev/](https://sonarqube.werockstar.dev/)
- ArgoCD - [https://argocd.werockstar.dev/](https://argocd.werockstar.dev/)

## Workshop URL
- Health Check: `GET: api/v1/health`
- Group 1
	- Dev: [https://group-1-b1-dev.werockstar.dev/](https://group-1-b1-dev.werockstar.dev/)
	- Prod: [https://group-1-b1-prod.werockstar.dev/](https://group-1-b1-prod.werockstar.dev/)
- Group 2
	- Dev: [https://group-2-b1-dev.werockstar.dev/](https://group-2-b1-dev.werockstar.dev/)
	- Prod: [https://group-2-b1-prod.werockstar.dev/](https://group-2-b1-prod.werockstar.dev/)
- Group 3
	- Dev: [https://group-3-b1-dev.werockstar.dev/](https://group-3-b1-dev.werockstar.dev/)
	- Prod: [https://group-3-b1-prod.werockstar.dev/](https://group-3-b1-prod.werockstar.dev/)
- Group 4
	- Dev: [https://group-4-b1-dev.werockstar.dev/](https://group-4-b1-dev.werockstar.dev/)
	- Prod: [https://group-4-b1-prod.werockstar.dev/](https://group-4-b1-prod.werockstar.dev/)
- Group 5
	- Dev: [https://group-5-b1-dev.werockstar.dev/](https://group-5-b1-dev.werockstar.dev/)
	- Prod: [https://group-5-b1-prod.werockstar.dev/](https://group-5-b1-prod.werockstar.dev/)

# HongJot Diagram

```mermaid
sequenceDiagram
	Mobile App ->> HongJot API: Upload Image to S3 Bucket
	activate Mobile App
	HongJot API ->> S3 Bucket: Store Image
	HongJot API ->> Mobile App: success
	deactivate Mobile App
	S3 Bucket ->> Lambda Function: (Event Trigger)
	Lambda Function ->> Amazon Textract: Extract Text from Image
	Amazon Textract ->> Lambda Function: Slip Expense info
	Lambda Function ->> HongJot API: Send Slip Expense info
	HongJot API ->> PostgreSQL Database: Store Expense info
	Mobile App ->> HongJot API: Get Expense Summary (Spender Requests Summary) Retrieve Expense Summary
	activate Mobile App
	HongJot API ->> PostgreSQL Database: Get Expense Summary Data
	PostgreSQL Database ->> HongJot API: Return Summary Data
	HongJot API ->> Mobile App: Show Expense Summary Data
	deactivate Mobile App
```

## Infrastructure

We have created the infrastructure by using Terraform. The infrastructure consists of the following:

- `Kubernetes Cluster (EKS)` - Managed Kubernetes Service
- `PostgreSQL (RDS)` - Relational Database (Managed Service)
- `SonarQube` - Static Code Analysis
- Github (see `.github/workflows` directory)
	- Github Action
	- Github Container Registry
- ArgoCD - Continuous Delivery
- Cloudflare - DNS Management

## Getting Started

### Step 0: IaC (Infrastructure as Code) ✅
- Create **IAM** account for `Terraform`
- Authenticate with AWS
	- Option 1: `aws configure` - Configure your AWS credentials with keypair
	- Option 2: Set environment variable
		- `export AWS_ACCESS_KEY_ID=<KEY>`
		- `export AWS_SECRET_ACCESS_KEY=<SECRET>`
- Create `ESK Cluster`
	- `cd infra/iac/eks`
	- `terraform init`
	- `terraform apply`
	- `Terraform` will require `Cloudflare` API key, you can get it from the `Cloudflare` dashboard
		- Option 1: Enter API token on Terraform prompt
		- Option 2: Export environment variable that provide for Terraform
	- And then Terraform will proceed to create the EKS Cluster
	- Waiting and enjoy your coffee
- Create `RDS (Postgres)`
	- `cd infra/iac/rds`
	- `terraform init`
	- `terraform apply -auto-approve`
	- You need to input username and password for the RDS
	- Terraform will create the RDS
	- And then output the RDS endpoint
- Create `SonarQube`
	- `cd infra/iac/sonarqube`
	- `terraform init`
	- `terraform apply -auto-approve`
	- You need to input `Cloudflare` API key
	- Terraform will create the `SonarQube`
	- And then output the SonarQube endpoint
	- You can access default username and password via `infra/iac/sonar/ansible`
	- Run `make get-cred` in Ansible directory
- Mapping DNS with `Cloudflare`
	- We have created the DNS mapping for every group in the workshop such as:
	- Dev
		- `group-1-b1-dev`: `group-1-b1-dev.werockstar.dev`
	- Prod
		- `group-1-b1-prod`: `group-1-b1-prod.werockstar.dev`
- Create `ArgoCD` application (No need to do anything because we have done it for demo purpose)
	- ArgoCD will automatically deploy the application to the EKS cluster
- Importantly, you need to destroy the infrastructure after the workshop
	- `terraform destroy` in each directory

### Step 1: Fork the repository and setup Github Actions ✅
- Fork `workshop-summer` repository and name it as `workshop-summer-<GROUP_NO>-<BATCH_NO>` (e.g. `workshop-summer-group-1-b1`)
- Enable Github Actions in the repository
- Replace the `<GROUP_NO>` pattern via `auto-replace-group.sh`
- Setup project on `SonarQube` manually
  - Create project on `SonarQube` with the same name as the repository
  - Generate SonarQube token and create secret on Github named as `SONAR_TOKEN`
  - Add `SONAR_HOST_URL` secret on Github with the value of https://sonarqube.werockstar.dev
- Commit and push the changes to the repository
- View the `Github Actions` and see the workflow running
- Observe analysis result on `SonarQube` dashboard

### Step 2: Create ArgoCD application
- Go to ArgoCD dashboard [https://argocd.werockstar.dev/](https://argocd.werockstar.dev/)
- Setup GitOps สำหรับ Development
  - กด `+ New App` แล้วใส่ข้อมูลดังนี้
  - Application Name: `<GROUP_NO>-<BATCH_NO>-dev` (e.g. `group-1-b1-dev`)
  - Project Name: `default`
  - SYNC POLICY: `Automatic`
  - Repository URL: `https://github.com/<your-github>/workshop-summer-<GROUP_NO>-<BATCH_NO>`
  - Revision: `main`
  - Path: `infra/gitops/dev`
  - Cluster URL: `https://kubernetes.default.svc`
  - กด `Create` มุมบนซ้าย
  - ภาวะณา
- Setup GitOps สำหรับ Production env
   - กด `+ New App` แล้วใส่ข้อมูลดังนี้
   - Application Name: `<GROUP_NO>-<BATCH_NO>-prod` (e.g. `group-1-b1-prod`)
   - Project Name: `default`
   - SYNC POLICY: `Automatic`
   - Repository URL: `https://github.com/<your-github>/workshop-summer-<GROUP_NO>-<BATCH_NO>`
   - Revision: `main`
   - Path: `infra/gitops/prod`
   - Cluster URL: `https://kubernetes.default.svc`
   - กด `Create` มุมบนซ้าย

## 🏁 Development เริ่มยังไง?

ใน Repository นี้เราใช้ Makefile ในการทำงานได้ ดังนั้นสามารถสั่งรันง่ายๆ ผ่าน `make` ได้เลย

1.เริ่มต้นลองสั่งติดตั้ง dependencies ของ Go มาก่อน

```console
go mod tidy
```

2.จากนั้น set environment variable โดยสร้าง file ใหม่ชื่อ `.env` แล้ว copy content จาก `.env.template` มา แล้วเปลี่ยน `db:5432` เป็น `localhost:5432`

```
ENV=LOCAL
LOCAL_DATABASE_POSTGRES_URI=postgres://postgres:password@localhost:5432/hongjot?sslmode=disable
LOCAL_SERVER_PORT=8080

# Features Flags
LOCAL_ENABLE_CREATE_SPENDER=false
```

3.Export environment variable ด้วยเครื่องมืออย่าง [direnv](https://direnv.net/) หรือจะใช้คำสั่งนี้ก็ได้

```shell
# Using source (.)
source .env

# or using export
export $(cat .env)
```

4.สร้าง PostgreSQL บน local machine ผ่าน `docker-compose` ด้วยคำสั่ง

```console
docker-compose up -d
```

5.จากนั้นสั่งรันได้เลย

```console
make run
```

หรือถ้าใครใช้ [Makefile](https://makefiletutorial.com/) ไม่ได้ก็ใช้คำสั่งตรงก็ได้ โดยเข้าไปดูแต่ละคำสั่งใน `makefile` ได้เลย

```console
go run main.go
```

เมื่อ Server ทำงานได้ควรจะสามารถเรียกจาก [http://localhost:8080/api/v1/health](http://localhost:8080/api/v1/health) ได้

```console
make health

Checking the health of the server...
curl http://localhost:8080/api/v1/health
{"message":"api is ready and connected to database","status":"ok"}
```

## 👻 รัน Test ยังไง?

โปรเจกนี้มี 2 ระดับคือ `unit`, `integration` รันได้ดังนี้

### 🪛 Unit

```console
make test
```

### ⚙️ Integration

Run ผ่าน Docker
```console
make test-it-docker
```

Run ตรง
```console
make test-it
```

**หมายเหตุ**: ตอนเขียน integration test ต้องตั้งชื่อเป็น format `Test...IT` ไม่งั้นตอน run มันจะข้ามไป

## ⚓ ใช้งาน pre-commit
[pre-commit](https://pre-commit.com/) คือ framework ที่ใช้ run script (hooks) ก่อน commit หรือ push ผ่าน Git โดยให้ทำการติดตั้งตาม[คู่มือ](https://pre-commit.com/#install) จากนั้น run คำสั่ง

```console
make setup-pre-commit
```

ทีนี้เวลาเรา commit หรือ push มันก็จะไป run คำสั่งต่าง ๆ ที่จะดักปัญหาก่อนไม่ให้ CI/CD pipeline ของเราพังนั่นเอง

## 🗃️ ใช้งาน database migration
Project นี้เราใช้ [goose](https://github.com/pressly/goose) เป็น database migration tool โดย database script จะเก็บไว้อยู่ที่ directory `migration`

ตอนที่เราสร้าง script ใหม่ก็สามารถ run คำสั่ง

```console
make new-migration name=0X_name_with_underscore
```

หรือจะสร้างโดย copy file จาก template ชื่อ `00_example.sql.template` แล้วสร้าง file ใหม่โดยต้องตั้งชื่อเป็น `0X_<script_name_with_underscore>.sql` ก็ได้

Migration file ใหม่ที่ได้จะอยู่ที่ directory `migration` ที่มีใส่ content ดังนี้

```sql
-- +goose Up
-- +goose StatementBegin
SELECT 'up SQL query';
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
SELECT 'down SQL query';
-- +goose StatementEnd
```

จากนั้นก็ทำการเขียน SQL statement ที่ต้องการ

เวลาเรา run server ขึ้นมามันจะทำการ apply migration ให้อัตโนมัติ แต่ในส่วนของ integration test ต้องเขียน apply และ rollback ด้วย ประมาณนี้

```go
import (
	"database/sql"
	"testing"

	"github.com/KKGo-Software-engineering/workshop-summer/config"
	"github.com/KKGo-Software-engineering/workshop-summer/migration"
	_ "github.com/lib/pq"
)

func TestSomethingIT(t *testing.T) {
	t.Run("create spender succesfully when feature toggle is enable", func(t *testing.T) {
		sql, err := getTestDatabaseFromConfig()
		if err != nil {
			t.Error(err)
		}
		migration.ApplyMigrations(sql)
		defer migration.RollbackMigrations(sql)

		// เขียน test ต่อได้เลย
	})
}

func getTestDatabaseFromConfig() (*sql.DB, error) {
	cfg := config.Parse("DOCKER")
	sql, err := sql.Open("postgres", cfg.PostgresURI())
	if err != nil {
		return nil, err
	}
	return sql, nil
}
```
