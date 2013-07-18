class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'
  
  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end
  
  def index
    if Shop.where(:name => ShopifyAPI::Shop.current.name).exists?
      session[:shop] = Shop.where(:name => ShopifyAPI::Shop.current.name).first
    else 
      shop = Shop.new(:name => ShopifyAPI::Shop.current.name, :url => "http://#{ShopifyAPI::Shop.current.domain}", :installed => true, :phone_number => ShopifyAPI::Shop.current.phone)
      shop.save
      session[:shop] = shop
      init_webhooks
    end
  end
  
  def init_webhooks
    topics = ["orders/payment"]
    topics.each do |topic|
      webhook = ShopifyAPI::Webhook.create(:format => "json", :topic => topic, :address => "http://#{DOMAIN_NAMES[RAILS_ENV]}/webhooks/#{topic}")
      raise "Webhook invalid: #{webhook.errors}" unless webhook.valid?
    end
  end
end