package auth

import "testing"

func TestCheckUsernameAndPassword(t *testing.T) {
	cases := []struct {
		username string
		password string
		want     bool
	}{
		{"user", "secret", true},
		{"user", "wrong-secret", false},
	}

	for _, tc := range cases {
		got := Check(tc.username, tc.password)
		if got != tc.want {
			t.Errorf("Check(%s, %s) = %v; want %v", tc.username, tc.password, got, tc.want)
		}
	}
}
