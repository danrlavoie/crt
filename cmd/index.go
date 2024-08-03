/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"database/sql"
	"github.com/spf13/cobra"
	"path/filepath"
	"strings"
)

// indexCmd represents the index command
var indexCmd = &cobra.Command{
	Use:   "index",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("index called")
		mediaFileTypes := []string{"mkv","mp4","avi","wmv"}
		_ = mediaFileTypes
		_ = sql.Drivers
		// Open DB connection
		//db, err := sqlite.Open("databasefile.db")
		//defer db.Close()
		// Get the fileroot for indexing
		fileroot := args[0] // or an env variable
		// Walk through each file in the fileroot
		err := filepath.Walk(fileroot, func(path string, info os.FileInfo, err error) error {
			if (! info.IsDir()) {
				//fmt.Println(info.Name())
				//fmt.Println(filepath.Ext(path))
				cmd := exec.Command("md5sum", path)
				var out strings.Builder
				cmd.Stdout = &out
				err = cmd.Run()
				execOut := out.String()
				md5, _, _ := strings.Cut(execOut, " ")
				fmt.Println(path, md5)
			}
			return nil
		})

		_ = err	
		// If the filetype is in the list of media file extensions

		// Record the absolute filepath
		// Record the md5 hash
		// Record the runtime of the file
		// Upsert, where md5 hash is equal, the filepath and metadata
		//stmt, err := db.Prepare()
		//_, err :=stmt.Exec()
		// After walking through all files in the fileroot
		// Select all files from the file table which had an updated date earlier than today
		// Mark them as soft-deleted
	},
}

func init() {
	rootCmd.AddCommand(indexCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// indexCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// indexCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
