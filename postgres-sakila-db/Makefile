log_file = /tmp/sakila-postgresql-session.log

build: postgres-sakila-schema.sql
	psql --quiet --log-file=$(log_file) < $<
install: postgres-sakila-insert-data.sql
	psql --quiet --log-file=$(log_file) < $<
uninstall: postgres-sakila-delete-data.sql
	psql --quiet --log-file=$(log_file) < $<
clean: postgres-sakila-drop-objects.sql
	psql --quiet --log-file=$(log_file) < $<
