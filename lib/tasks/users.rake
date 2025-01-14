# lib/tasks/users.rake
namespace :users do
    desc "List all users with their data and hashed passwords"
    task list: :environment do
      puts "Listing all users with their data and hashed passwords:"
      User.find_each do |user|
        puts "ID: #{user.id}"
        puts "Username: #{user.username}"
        puts "Email: #{user.email}"
        puts "Password Digest: #{user.password_digest}" # Gehashtes Passwort
        puts "-" * 40
      end
    end
  end