class UserMailer < ApplicationMailer
    def send_custom_email(to_email)
      @greeting = "Hallo!"
      mail(
        to: to_email,
        subject: 'Deine benutzerdefinierte Nachricht',
        from: ENV['SMTP_USERNAME'],
        template_path: 'user_mailer',
        template_name: 'send_custom_email'
      )
    end

    def send_registration_email(to_email, link)
        @greeting = "Guten Tag @to_email"
        base_url = Rails.application.config.base_url
        token = link.token
        @register_url = "#{base_url}/signup/#{token}"
        @expires = link.expires.strftime("%d.%m.%Y %H:%M")
        mail(
            to: to_email,
            subject: 'Willkommen bei Exproware',
            from: ENV['SMTP_USERNAME'],
            template_path: 'user_mailer',
            template_name: 'send_registration_email'
        )
    end
end  