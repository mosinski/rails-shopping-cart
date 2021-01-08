class CheckoutsController < ApplicationController
  def index
    @transactions = gateway.transaction.search
  end

  def new
    @client_token = gateway.client_token.generate#(customer_id: cart_token)
    @order = current_cart.order
  end

  def show
    @transaction = gateway.transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
  end

  def create
    result = gateway.transaction.sale(
      checkout_params.to_h.merge(
        amount: current_cart.order.amount,
        options: {
          submit_for_settlement: true
        }
      )
    )

    if result.success? || result.transaction
      redirect_to checkout_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to new_checkout_path
    end
  end

  def _create_result_hash(transaction)
    status = transaction.status

    if Transaction::SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your test transaction has been successfully processed. See the Braintree API response and try again."
      }
    else
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your test transaction has a status of #{status}. See the Braintree API response and try again."
      }
    end
  end

  private

  def gateway
    @_gateway ||= Braintree::Configuration.gateway
  end

  def checkout_params
    params.require(:checkout).permit(
      :payment_method_nonce,
      customer: %i(first_name last_name company phone email),
      billing: %i(first_name last_name company street_address locality)
    )
  end
end
