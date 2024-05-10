package eslip

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestUploadToS3(t *testing.T) {
	t.Run("should able to upload image to S3 bucket", func(t *testing.T) {
		f, _ := os.CreateTemp("", "eslip1.jpg")
		defer f.Close()
		defer os.Remove(f.Name())

		e := echo.New()
		defer e.Close()

		req := httptest.NewRequest(http.MethodPost, "/", nil)
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)

		loc, err := UploadToS3(c, "eslip1.jpg", f)

		assert.NoError(t, err)
		assert.Equal(t, "location/on/s3/bucket/eslip1.jpg", loc)
	})

}
