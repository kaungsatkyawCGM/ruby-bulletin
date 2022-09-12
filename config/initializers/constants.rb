module Constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  EXPORT_USER_CSV_HEADER = ["id", "name", "email", "phone", "role", "join date"]
  IMPORT_USER_CSV_HEADER = ["name", "email", "phone", "role", "password"]
  ADMIN_ROLE = "1"
  USER_ROLE = "0"
end