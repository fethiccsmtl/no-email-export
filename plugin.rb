# name: no-email-export
# about: Removes email from user CSV export
# version: 0.1
# authors: Fethi Bey Abi Ayad

after_initialize do
  module ::Jobs::ExportCsvFileExtension
    def get_base_user_array(user)

      user_array = super
  
      user_array[3] = "#######"  # Replace Primary Email
      user_array[19] = "#######" # Replace Secondary Email
  
      user_array
    end
  end

  # On injecte notre module AVANT le chargement du job
  ::Jobs::ExportCsvFile.prepend(::Jobs::ExportCsvFileExtension)
end
