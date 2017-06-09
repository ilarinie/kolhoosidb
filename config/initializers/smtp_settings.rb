ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "gmail.com",
    :user_name => "kolhoosidb@gmail.com",
    :password => "haistapaska123",
    :authentication => "plain",
    :enable_starttls_auto => true
}
