package eslip

import (
	"fmt"
	"mime/multipart"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
)

func Upload(c echo.Context) error {
	form, err := c.MultipartForm()
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"message": "Failed to parse form",
			"error":   err.Error(),
		})
	}
	images := form.File["images"]
	var locations []string
	for _, image := range images {
		fmt.Printf("Uploading file: %+v\n", image.Filename)
		src, err := image.Open()
		if err != nil {
			return c.JSON(http.StatusBadRequest, map[string]string{
				"message": "Failed to parse form",
				"error":   err.Error(),
			})
		}
		defer src.Close()

		// upload to AWS S3 bucket
		loc, err := UploadToS3(c, image.Filename, src)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"message": "Failed to upload image",
				"error":   err.Error(),
			})
		}
		locations = append(locations, loc)
	}

	return c.JSON(http.StatusOK, map[string]string{
		"message":   "Image uploaded successfully",
		"locations": strings.Join(locations, ","),
	})
}

func UploadToS3(c echo.Context, filename string, src multipart.File) (string, error) {
	// Assume that the file is uploaded to S3 bucket successfully
	return "location/on/s3/bucket/" + filename, nil
	// Create an AWS session
	// sess, err := session.NewSession(&aws.Config{
	// 	Region: aws.String(os.Getenv("AWS_REGION")),
	// })
	// if err != nil {
	// 	return "", err
	// }

	// Upload the file to S3
	// result, err = s3.New(sess).PutObject(&s3.PutObjectInput{
	// 	Bucket: aws.String(os.Getenv("AWS_BUCKET")),
	// 	Key:    aws.String(filename),
	// 	Body:   src,
	// })
	// if err != nil {
	// 	return "", err
	// }

	// return result.Location, nil
}
