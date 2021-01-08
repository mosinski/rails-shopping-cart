class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def amount
    price * quantity
  end
end
