desc 'send outstanding stock emails'
namespace :spree_stock_email do
  task :send_emails => :environment do
    Spree::Variant.joins(:stock_emails).where(spree_stock_emails: { sent_at: nil }).uniq.find_each do |v|
      if v.is_master?
        next unless v.product.in_stock?
      else
        next unless v.in_stock?
      end

      if defined?(Spree::AssembliesPart) == 'constant' && v.product.assembly? && v.respond_to?(:can_supply_assembly?)
        if v.is_master? && v.product.has_variants?
          # check if the parts are in stock for any variant of the product
          next unless v.product.can_supply_assembly?
        else
          # either a plain master with no variants or a plain variant
          # check if the parts are in stock for this specific variant
          next unless v.can_supply_assembly?
        end
        Spree::StockEmail.notify(v, 10)
      else
        count = v.is_master? ? v.product.total_on_hand : v.total_on_hand
        Spree::StockEmail.notify(v, count)
      end
    end
  end
end
