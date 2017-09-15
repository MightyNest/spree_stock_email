desc 'send outstanding stock emails'
namespace :spree_stock_email do
  task :send_emails => :environment do
    Spree::Variant.joins(:stock_emails).where(spree_stock_emails: { sent_at: nil }).uniq.find_each do |v|
      if v.in_stock?
        if defined?(Spree::AssembliesPart) == 'constant' && v.product.assembly?
          if v.parts.all? { |p| p.in_stock? }
            # check if the parts are in stock
            Spree::StockEmail.notify(v, 10)
          end
        else
          count = v.total_on_hand
          Spree::StockEmail.notify(v, count)
        end
      end
    end
  end
end
