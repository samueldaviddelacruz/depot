class Order < ApplicationRecord
    has_many :line_items, dependent: :destroy
    enum pay_type: {
        "Check" => 0,
        "Credit card" => 1,
        "Purchase order" => 2
    }
    validates :name, :address, :email, presence: true
    validates :pay_type, inclusion: pay_types.keys

    def add_line_items_from_cart(cart)
        cart.line_items.each do |item|
            item.cart_id = nil # Remove the cart id from the line item
            line_items << item # Add the line item to the order
        end
    end
end
