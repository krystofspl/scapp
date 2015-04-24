class Settings < Settingslogic
  # This is a workaround because of incompatibility between heroku and settingslogic (need to specify host)
  # Use scapp_heroku.yml if scapp.yml doesn't exist
  if File.exists?("#{Rails.root}/config/scapp.yml")
    source "#{Rails.root}/config/scapp.yml"
  else
    source "#{Rails.root}/config/scapp_heroku.yml"
  end
  namespace Rails.env
end