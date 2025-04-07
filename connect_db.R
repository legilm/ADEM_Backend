library(DBI)
library(RPostgres)
library(tidyverse)
library(glue)

connect_db <- function(){
    DBI::dbConnect(
        RPostgres::Postgres(),
        dbname = Sys.getenv("DB_NAME"),
        host = Sys.getenv("DB_HOST"),
        port = 5432,
        user = Sys.getenv("DB_USER"),
        password = Sys.getenv("DB_PASSWORD")
    )
}

conn <- connect_db()



get_all_companies <- function() {
    con <- connect_db()
    output <- DBI::dbGetQuery(conn, "SELECT * FROM adem.companies")
    DBI::dbDisconnect(conn)
    return(output)
}

get_vacancies_by_skill <- function(skill_label) {
    conn <- connect_db()
    sql <- glue::glue_sql("
    SELECT v.occupation
    FROM adem.vacancies v
    JOIN adem.vacancy_skills vs ON v.vacancy_id = vs.vacancy_id
    JOIN adem.skills s ON vs.skill_id = s.skill_id
    WHERE s.skill_label = {skill_label}
  ", .con = conn)