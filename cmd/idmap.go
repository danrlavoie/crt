/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"fmt"
	"os"
	"path"
	"database/sql"
	"github.com/spf13/cobra"
	"github.com/ryanbradynd05/go-tmdb"
)

var tmdbAPI *tmdb.TMDb

// idmapCmd represents the idmap command
var idmapCmd = &cobra.Command{
	Use:   "idmap",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("idmap called")

		api_key := os.Getenv("TMDB_API_KEY")
		fmt.Println(api_key)
		// path is the filepath to the repo root
		e, err := os.Executable()

		myPath := path.Join(path.Dir(e), "id_mappings")
		fmt.Println(myPath)

		config := tmdb.Config{
			APIKey: api_key,
			Proxies: nil,
			UseProxy: false,
		}
		tmdbAPI = tmdb.Init(config)
		movieGenres, err := tmdbAPI.GetMovieGenres(nil)

		movieGenreJSON, err := tmdb.ToJSON(movieGenres)
		fmt.Println(movieGenreJSON)

		// Open DB connection
		db, err := sql.Open("sqlite3", "media.db")
		defer db.Close()
		if err != nil {
			panic(err)
		}
	},
}

func init() {
	rootCmd.AddCommand(idmapCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// idmapCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// idmapCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
