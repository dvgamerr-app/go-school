package main

import (
	"context"
	"database/sql"
	"embed"
	"fmt"
	"os"

	_ "github.com/lib/pq"
	"github.com/pressly/goose/v3"
)

//go:embed migrations/*.sql
var embedMigrations embed.FS

func dataSource(host string, port int, user string, password string, dbname string) string {
	return fmt.Sprintf("host=%s port=%d user=%s dbname=%s sslmode=disable", host, port, user, dbname)
}

func argsParse() error {
	dirName := "migrations"
	ctx := context.Background()
	if len(os.Args) > 1 {
		if os.Args[1][0:1] == "-" {
			cmd := os.Args[1][1:]
			goose.SetBaseFS(embedMigrations)
			switch cmd {
			case "init":
				db := gooseConnectDatabase(ctx, "postgres")
				defer db.Close()
				return goose.RunContext(ctx, "CREATE DATABASE goschool;", db, dirName)
			case "clean":
				db := gooseConnectDatabase(ctx, "postgres")
				defer db.Close()
				return goose.RunContext(ctx, "DROP DATABASE goschool;", db, dirName)
			case "up":
				db := gooseConnectDatabase(ctx, "goschool")
				defer db.Close()
				return goose.UpContext(ctx, db, dirName)
			case "down":
				db := gooseConnectDatabase(ctx, "goschool")
				defer db.Close()
				return goose.DownContext(ctx, db, dirName)
			default:
				fmt.Println("Unknow is command, goose:", cmd)
			}
		}
	}
	return nil
}

func gooseConnectDatabase(ctx context.Context, dbName string) *sql.DB {
	db, err := sql.Open("postgres", dataSource("db-postgres.database.aide", 5432, "postgres", "", dbName))
	if err != nil {
		panic(err)
	}

	if err = db.Ping(); err != nil {
		panic(err)
	}

	return db
}

func init() {

	if err := goose.SetDialect("postgres"); err != nil {
		panic(err)
	}
}

func main() {
	err := argsParse()
	if err != nil {
		panic(err)
	}
	// run app
}
