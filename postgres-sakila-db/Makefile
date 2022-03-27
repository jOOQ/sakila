log_file = /tmp/sakila-postgresql-session.log

build: postgres-sakila-schema.sql
	sed "s_postgres_\"${USERNAME}\"_g" $< | psql --quiet --log-file=$(log_file)
install: postgres-sakila-insert-data.sql
	psql --quiet --log-file=$(log_file) < $<
uninstall: postgres-sakila-delete-data.sql
	psql --quiet --log-file=$(log_file) < $<
clean: postgres-sakila-drop-objects.sql
	psql --quiet --log-file=$(log_file) < $<
