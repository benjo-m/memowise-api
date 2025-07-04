class RodauthApp < Rodauth::Rails::App
  # primary configuration
  configure RodauthMain

  # secondary configuration
  # configure RodauthAdmin, :admin

  route do |r|
    r.rodauth # route rodauth requests

    # ==> Authenticating requests
    # Call `rodauth.require_account` for requests that you want to
    # require authentication for. For example:
    #
    # authenticate /dashboard/* and /account/* requests
    if r.path.start_with?("/decks") || r.path.start_with?("/flashcards")
      rodauth.require_account
    end

    # ==> Secondary configurations
    # r.rodauth(:admin) # route admin rodauth requests
  end
end
