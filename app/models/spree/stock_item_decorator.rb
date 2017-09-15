Spree::StockItem.class_eval do
  after_save :send_stock_emails

  def send_stock_emails
    if variant.in_stock? && variant.total_on_hand >= Spree::StockEmailConfig::Config.notify_threshold
      Spree::StockEmail.notify(variant)
    end
  end
end
