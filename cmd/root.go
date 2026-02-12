package cmd

import (
	"fmt"
	"io/fs"
	"os"

	"github.com/spf13/cobra"
)

var embeddedFS fs.FS

var rootCmd = &cobra.Command{
	Use:   "compose-cd",
	Short: "Scaffold Docker Compose deployment repos",
	Long:  "ArgoCD-like GitOps deployment scaffolding for Docker Compose on VPS.",
}

func Execute(templateFS fs.FS) {
	embeddedFS = templateFS
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
