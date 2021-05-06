module Services
  class Crawl
    def initialize(url)
      @url = url
      @agent = Mechanize.new
    end

    def get_page
      @agent.get @url
    end

    def perform
      get_page
      return @agent
      # dưới đây là các method mà Mechanize cho phép thực thi để lấy ra dữ liệu dựa trên tên thẻ, tên class, thuộc tính html      
      # @product.old_price_rub = @agent.page.search('.product-price.old').map(&:text).map(&:strip).uniq.first.gsub(" ", "").to_i
      # @product.current_price_rub = @agent.page.search('.product-discount-price').map(&:text).map(&:strip).uniq.first.gsub(" ", "").to_i
      # @product.current_price_vnd = @product.current_price_rub * 330 + xxx000
      # @product.discount = @agent.page.search('.nohover').map(&:text).map(&:strip).uniq.first.split(" ").first.gsub("−", "").to_i
      # @product.image_url = @agent.page.image_with(:src => /media\/products/).url.to_s
      # diameter_position = @agent.page.search('.property-description-title').map(&:text).map(&:strip).map(&:strip).index("Диаметр:") + 1
      # @product.diameter = @agent.page.search("#product-cart > div.product-text-accordion-wrapper > div.product-text-accordion.first.opened > div > div.property-descriptions > div:nth-child(#{diameter_position}) > div.property-description-content").map(&:text).map(&:strip).uniq.first.to_i
      # @product.stock_status = agent.page.search('.js-product-cart-add').present? ? :stocking : :out_of_stock
    end
  end
end