output "db-config" {
  description = "Database credentials"
  value = {
    user = aws_db_instance.main.username
    password = aws_db_instance.main.password
    hostname = aws_db_instance.main.address
    port = aws_db_instance.main.port
    database = aws_db_instance.main.db_name
  }
}