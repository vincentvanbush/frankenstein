class CreateAdminService
  def call
    user = Admin.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.first_name = 'Admin'
        user.last_name = 'Adminovic'
        user.address = 'Belgrade 123'
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
      end
  end
end
