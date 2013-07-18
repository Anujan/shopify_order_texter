class WebhookController < ApplicationController

  before_filter :verify_webhook, :except => 'verify_webhook'

  def order_payment
    data = ActiveSupport::JSON.decode(request.body.read)
    shop_url = request.headers['x-shopify-shop-domain']
    @shop = Shop.where(:url => shop_url)
    if (@shop.exists? && !@shop.phone_number.blank?) 
      twilio_sid = ENV["TWILIO_SID"]
      twilio_token = ENV["TWILIO_TOKEN"]
      twilio_phone_number = ENV["TWILIO_PHONE_NUMBER"]
      notify_number = @shop.phone_number
      twilio = Twilio::REST::Client.new twilio_sid, twilio_token

      twilio.account.sms.messages.create(
        :from => twilio_phone_number,
        :to => notify_number,
        :body => "An order from #{data["customer"]["email"]} has been paid for the amount of #{data["total_price"]}."
        )
    end
    head :ok
  end
  
  private
  
  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest  = OpenSSL::Digest::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ShopifyOrderTexter::Application.config.shopify.secret, data)).strip
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end

end