class PaypalController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:ipn] #Otherwise the request from PayPal wouldn't make it to the controller
  def index
  	get_pay_button
  end
  def ipn
    Rails.logger.debug "ipnipnipnipn"
  end
  def get_pay_button
  	@api = PayPal::SDK::ButtonManager::API.new(
	  :mode      => "sandbox",  # Set "live" for production
	  :app_id    => "APP-80W284485P519543T",
	  :username  => "adaviddsc-facilitator_api1.gmail.com",
	  :password  => "VXXVJ4KLAXRF9JXL",
	  :signature => "ArQS3pWsUidJjC56DabpUaB9IfRtASns3MoilmGQs1gWL96q0s6yu2Z0" )

	# Build request object
	@bm_create_button = @api.build_bm_create_button({
	  :ButtonType => "BUYNOW",
	  :ButtonCode => "HOSTED",
	  :ButtonVar => ["item_name=Testing","amount=5","return=http://localhost:3000/samples/button_manager/bm_create_button","notify_url=http://localhost:3000/samples/button_manager/ipn_notify"] })

	# Make API call & get response
	@bm_create_button_response = @api.bm_create_button(@bm_create_button)

	# Access Response
	if @bm_create_button_response.success?
	  @bm_create_button_response.Website
	  @bm_create_button_response.Email
	  @bm_create_button_response.HostedButtonID
	else
	  @bm_create_button_response.Errors
	end
=begin
    event = self.batch.event

    @api = PayPal::SDK::ButtonManager::API.new

    var = {
      item_name: event.title, # 商品名稱
      item_number: event.id,  # 商品id
      amount: event.price,    # 金額
      quantity: self.count,   # 數量
      custom: self.order_id,  # UID
      currency_code: event.dollar_type,
      :return => Rails.application.routes.url_helpers.pay_finish_url(host),
      email: paider[:email],
      first_name: paider[:first_name],
      last_name: paider[:last_name],
      address1: paider[:address]
    }

    # Build request object
    @bm_create_button = @api.build_bm_create_button(
      ButtonType: "BUYNOW",
      ButtonCode: "HOSTED",
      ButtonVar: var.map {|k,v| "#{k}=#{v}"}
    )

    # Make API call & get response
    @bm_create_button_response = @api.bm_create_button(@bm_create_button)
    if @bm_create_button_response.success?
      @bm_create_button_response.Website.gsub(/https.*btn_buynow_LG\.gif/, '/images/paypal_button.png')
    else
      nil
    end
=end
  end
end
