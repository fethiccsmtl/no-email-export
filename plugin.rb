# name: no-email-export
# about: Removes email from user CSV export
# version: 0.1
# authors: Your Name

after_initialize do
    module ::NoEmailExport
      module RemoveEmailsFromExport
        def execute(args)
          Rails.logger.warn("🔍 Plugin no-email-export: intercepted export job for #{args[:type]}")
          return super(args) unless args[:type] == 'user_list'
  
          rows = []
          headers = []
  
          User.real.includes(:groups).find_each do |user|
            row = {
              "Username" => user.username,
              "Name" => user.name,
              "Created At" => user.created_at,
              "Groups" => user.groups.pluck(:name).join(", ")
            }
            headers = row.keys if headers.empty?
            rows << row
          end
  
          file_path = CsvExport.export(
            headers,
            rows,
            "user_list"
          )
  
          StaffExport.create!(
            target_user_id: args[:current_user_id],
            file: file_path,
            status: StaffExport.statuses[:pending]
          )
        end
      end
    end
  
    ::Jobs::ExportCsvFile.prepend(::NoEmailExport::RemoveEmailsFromExport)
end