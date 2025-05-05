# frozen_string_literal: true

after_initialize do
    module ::NoEmailUserExport
      class Engine < ::Rails::Engine
        engine_name "no_email_user_export"
        isolate_namespace NoEmailUserExport
      end
    end
  
    require_dependency 'admin/users_list_controller'
  
    module ::Admin::UsersListControllerExtension
      def render_csv(users)
        csv = CSV.generate do |csv_rows|
          csv_rows << [
            I18n.t("admin.users.csv.username"),
            I18n.t("admin.users.csv.name"),
            I18n.t("admin.users.csv.created_at"),
            I18n.t("admin.users.csv.last_seen_at"),
            I18n.t("admin.users.csv.ip_address")
          ]
  
          users.each do |user|
            csv_rows << [
              user.username,
              user.name,
              user.created_at,
              user.last_seen_at,
              user.ip_address
            ]
          end
        end
  
        send_data(csv.encode("UTF-8"), type: "text/csv; charset=utf-8; header=present", filename: "users.csv")
      end
    end
  
    ::Admin::UsersListController.prepend ::Admin::UsersListControllerExtension
  end