package scaffold

import (
	"fmt"
	"strings"
	"text/template"

	"github.com/Masterminds/sprig/v3"
)

func buildFuncMap() template.FuncMap {
	f := sprig.TxtFuncMap()

	// splitWords splits a string by whitespace into a slice.
	// Used for: app_command -> Docker command array
	f["splitWords"] = func(s string) []string {
		return strings.Fields(s)
	}

	// joinQuoted joins strings with `", "` separator for Docker command arrays.
	// Input: ["/app/service", "app", "start"]
	// Output: /app/service", "app", "start
	f["joinQuoted"] = func(ss []string) string {
		return strings.Join(ss, `", "`)
	}

	// containsStr checks if a string contains a substring.
	// Used for: 'local' in environments
	f["containsStr"] = func(s, substr string) bool {
		return strings.Contains(s, substr)
	}

	// splitComma splits a comma-separated string, trimming spaces.
	f["splitComma"] = func(s string) []string {
		parts := strings.Split(s, ",")
		for i := range parts {
			parts[i] = strings.TrimSpace(parts[i])
		}
		return parts
	}

	// joinBracketedCSV joins a slice into a bracketed comma-separated string.
	// Input: ["local", "dev", "prod"]
	// Output: [local, dev, prod]
	f["joinBracketedCSV"] = func(ss []string) string {
		return fmt.Sprintf("[%s]", strings.Join(ss, ", "))
	}

	return f
}
