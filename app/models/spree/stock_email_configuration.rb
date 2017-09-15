class Spree::StockEmailConfiguration < Spree::Preferences::Configuration
  preference :email_from, :string, default: "spree@example.com"
  preference :per_page, :integer, default: 15
  preference :notify_multiple, :integer, default: 1
end
