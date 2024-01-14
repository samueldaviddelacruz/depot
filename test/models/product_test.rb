require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products # load products fixture
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid? # assert product is not valid
    assert product.errors[:title].any? # assert product has an error on :title
    assert product.errors[:description].any? # assert product has an error on :description
    assert product.errors[:price].any? # assert product has an error on :price
    assert product.errors[:image_url].any? # assert product has an error on :image_url
  end
  test "product price must be positive" do
    product = Product.new(title: "My Book Title", description: "yyy", image_url: "zzz.jpg")
    product.price = -1 # set price to -1
    assert product.invalid? # assert product is not valid
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price] # assert product has an error on :price
    product.price = 0 # set price to 0
    assert product.invalid? # assert product is not valid
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price] # assert product has an error on :price
    product.price = 1 # set price to 1
    assert product.valid? # assert product is valid
  end
  def new_product(image_url)
    Product.new(title: "My Book Title", description: "yyy", price: 1, image_url: image_url)
  end
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif } # array of valid image urls
    bad = %w{ fred.doc fred.gif/more fred.gif.more } # array of invalid image urls
    ok.each do |name| # for each valid image url
      assert new_product(name).valid?, "#{name} must be valid" # assert product is valid
    end
    bad.each do |name| # for each invalid image url
      assert new_product(name).invalid?, "#{name} must be invalid" # assert product is not valid
    end
  end
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif") # create product with same title as fixture
    assert product.invalid? # assert product is not valid
    assert_equal ["has already been taken"], product.errors[:title] # assert product has an error on :title
  end
end
