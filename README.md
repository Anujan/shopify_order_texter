== README

This app uses Twilio's SMS service to text the shop owner when an order has been paid for. It was just something I cooked up to get familiar with the Shopify API.

== Setup

1. Change the Shopify API Key and Secret in config/initializers/omniauth.rb
2. Set the following enviroment variables
  Twilio SID -> TWILIO_SID
  Twilio token -> TWILIO_TOKEN
  Twilio Phone Number -> TWILIO_PHONE_NUMBER
  
  You can optionally hardcode these into app/controllers/webhook_controller.rb#order_payment