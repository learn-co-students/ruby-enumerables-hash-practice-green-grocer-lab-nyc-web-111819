def consolidate_cart(cart)
  hash_map = {}
  
  cart.each do |item|
    name = item.keys[0]
    value = hash_map[name]
    if value == nil
      inner_value = item[name]
      inner_value[:count] = 1
      hash_map[name] = inner_value
    else
      value[:count] += 1
    end
  end
  hash_map
end



def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        updated_name = "#{coupon[:item]} W/COUPON"
        if cart[updated_name]
          cart[updated_name][:count] += coupon[:num]
        else
          cart[updated_name] = {
            count: coupon[:num],
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
  
end



def apply_clearance(cart)

  cart.each do |item|
    clearance = item[1][:clearance]
    original_price = item[1][:price]

    if clearance
      discounted_price = original_price / 100 * 80
      item[1][:price] = discounted_price.round(2)
    end

  end
  cart
end

def checkout(cart, coupons)
  
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  cart_after_discounts = apply_clearance(cart_with_coupons)
  
  total = 0.0
  
  cart_after_discounts.keys.each {|cart_item|
    total += cart_after_discounts[cart_item][:price] * cart_after_discounts[cart_item][:count]
  }
  
  if total > 100
    total = (total * 0.9).round
  else total
  end

end

