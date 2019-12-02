def consolidate_cart(cart)
  hash = {}
  cart.each{|item| hash[item.keys[0]] = {:count => cart.count(item),:price => item[item.keys[0]][:price], :clearance => item[item.keys[0]][:clearance]}}
  hash
end

def apply_coupons(cart, coupons)
  cart.keys.each do |item|
    for coupon in coupons do
      if coupon[:item] == item and coupon[:num] <= cart[item][:count]
        if cart.include? "#{item} W/COUPON"
          cart["#{item} W/COUPON"][:count] += coupon[:num]
        else
          cart["#{item} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], :clearance => cart[item][:clearance],:count => coupon[:num]}
        end
        cart[item][:count] += -coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance] == true
      cart[item][:price] += -cart[item][:price]*0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  fixdCart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  total = 0
  fixdCart.keys.each do |item|
    total += fixdCart[item][:count]*fixdCart[item][:price]
  end
  if total > 100
    total += -total*0.1
  end
  total
end
