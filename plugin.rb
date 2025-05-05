# name: no-email-export
# about: Remove email from user CSV export
# version: 0.1
# authors: Your Name

after_initialize do
    require_dependency 'admin/users_controller'
  
    module ::NoEmailExport
      module UsersControllerPatch
        def export_csv
          users = User.real.includes(:groups)
          csv = CSV.generate do |csv|
            csv << ["Username", "Name", "Created At", "Groups"]
            users.find_each do |user|
              csv << [
                user.username,
                user.name,
                user.created_at,
                user.groups.pluck(:name).join(", ")
              ]
            end
          end
  
          send_data csv, type: 'text/csv; charset=utf-8; header=present', filename: "users.csv"
        end
      end
    end
  
    ::Admin::UsersController.prepend(::NoEmailExport::UsersControllerPatch)
  end