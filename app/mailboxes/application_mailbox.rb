class ApplicationMailbox < ActionMailbox::Base
  routing(/^login@/i => :logins)
end
