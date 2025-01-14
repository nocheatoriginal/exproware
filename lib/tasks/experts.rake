# lib/tasks/experts.rake
namespace :experts do
    desc "List all experts with their data and passwords"
    task list: :environment do
      puts "Listing all experts with their data and passwords:"
      Expert.find_each do |expert|
        puts "ID: #{expert.id}"
        puts "Unique ID: #{expert.unique_id}"
        puts "First Name: #{expert.first_name}"
        puts "Last Name: #{expert.last_name}"
        puts "Email: #{expert.email}"
        puts "Password: #{expert.password_digest}" # Achtung: Passwörter sollten normalerweise nicht im Klartext gespeichert werden
        puts "Password_2: #{expert.password}" # Achtung: Passwörter sollten normalerweise nicht im Klartext gespeichert werden
        puts "-" * 40
      end
    end
  end