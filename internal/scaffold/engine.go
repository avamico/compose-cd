package scaffold

import (
	"bytes"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"github.com/avamico/compose-cd/internal/config"
)

// Scaffold generates a project from the embedded templates.
func Scaffold(cfg *config.Config, outputDir string, templateFS fs.FS) error {
	data := cfg.TemplateData()
	funcMap := buildFuncMap()

	// Walk from "template" subdirectory within the embedded FS
	subFS, err := fs.Sub(templateFS, "template")
	if err != nil {
		return fmt.Errorf("accessing template directory: %w", err)
	}

	return fs.WalkDir(subFS, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		// Skip root
		if path == "." {
			return nil
		}

		// Check directory exclusion
		if d.IsDir() {
			if shouldExcludeDir(path, cfg) {
				return fs.SkipDir
			}
			return nil
		}

		// Check file exclusion
		if shouldExcludeFile(path, cfg) {
			return nil
		}

		// Read file content
		content, err := fs.ReadFile(subFS, path)
		if err != nil {
			return fmt.Errorf("reading %s: %w", path, err)
		}

		// Determine output path (strip .tmpl suffix)
		outPath := path
		isTemplate := strings.HasSuffix(path, ".tmpl")
		if isTemplate {
			outPath = strings.TrimSuffix(path, ".tmpl")
		}

		var output []byte
		if isTemplate {
			rendered, err := renderTemplate(path, string(content), data, funcMap)
			if err != nil {
				return fmt.Errorf("rendering %s: %w", path, err)
			}

			// Skip empty rendered files (fully conditional content)
			if strings.TrimSpace(rendered) == "" {
				return nil
			}

			output = []byte(rendered)
		} else {
			output = content
		}

		// Write file
		fullPath := filepath.Join(outputDir, outPath)
		return writeFile(fullPath, output)
	})
}

func renderTemplate(name, content string, data map[string]interface{}, funcMap template.FuncMap) (string, error) {
	tmpl, err := template.New(name).
		Delims("[[", "]]").
		Funcs(funcMap).
		Parse(content)
	if err != nil {
		return "", err
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return "", err
	}
	return buf.String(), nil
}

func writeFile(path string, content []byte) error {
	dir := filepath.Dir(path)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return fmt.Errorf("creating directory %s: %w", dir, err)
	}
	return os.WriteFile(path, content, 0644)
}
