# name: no-email-export
# about: Removes email from user CSV export
# version: 0.1
# authors: Your Name



after_initialize do
  # Crée une extension du contrôleur
  module ::ExportCsvControllerExtension
    def export_entity
      Rails.logger.warn("=== DEBUG: export_entity appelé ===")
      Rails.logger.warn("Params reçus : #{params.inspect}")
      super # Appelle la méthode originale
      Rails.logger.warn("=== DEBUG: export_entity fin de l'appel ===")
    end
  end

  # Injecte l'extension dans le contrôleur
  ::ExportCsvController.prepend(::ExportCsvControllerExtension)
end


# after_initialize do
#     module ::NoEmailExport
#       module PatchCsvExport
#         def create
#           result = super
  
#           Rails.logger.warn("Type d'export: #{self.export_type}")
          
#           if self.export_type == 'user_list'
#             csv = CSV.parse(result, headers: true)
#             csv.delete('Email')
  
#             # Réécriture du CSV sans la colonne
#             result = CSV.generate do |new_csv|
#               new_csv << csv.headers
#               csv.each { |row| new_csv << row.fields }
#             end
#           end
  
#           result
#         end
#       end
#     end
  
#     if defined?(CsvExport)
#       CsvExport.prepend(::NoEmailExport::PatchCsvExport)
#     end
#   end


# after_initialize do
#     module ::NoEmailExport
#       module RemoveEmailsFromExport
#         def execute(args)
#           Rails.logger.warn("🔍 Plugin no-email-export: intercepted export job for #{args[:type]}")
#           return super(args) unless args[:type] == 'user_list'
  
#           rows = []
#           headers = []
  
#           User.real.includes(:groups).find_each do |user|
#             row = {
#               "Username" => user.username,
#               "Name" => user.name,
#               "Created At" => user.created_at,
#               "Groups" => user.groups.pluck(:name).join(", ")
#             }
#             headers = row.keys if headers.empty?
#             rows << row
#           end
  
#           file_path = CsvExport.export(
#             headers,
#             rows,
#             "user_list"
#           )
  
#           StaffExport.create!(
#             target_user_id: args[:current_user_id],
#             file: file_path,
#             status: StaffExport.statuses[:pending]
#           )
#         end
#       end
#     end
  
#     ::Jobs::ExportCsvFile.prepend(::NoEmailExport::RemoveEmailsFromExport)
# end