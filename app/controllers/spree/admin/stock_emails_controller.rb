module Spree
  module Admin
    class StockEmailsController < ResourceController
      before_action :load_data

      protected
        def load_data
          @summary = summary_data
          @awaiting_users = Spree::StockEmail.awaiting_users
          @notified_users = Spree::StockEmail.notified_users
        end

        def summary_data
          conn = ActiveRecord::Base.connection
          sql = <<-SQL
            select
              se.variant_id,
              p.slug,
              p.name,
              v.sku,
              count(*) as requested,
              sum(quantity) as quantity
            from spree_stock_emails se
            join spree_variants v on v.id = se.variant_id
            join spree_products p on p.id = v.product_id
            where
              se.sent_at is null
            group by se.variant_id, p.slug, p.name, v.sku
            order by count(*) desc
          SQL
          conn.execute(sql).to_a
        end

        def collection

          return @collection if defined?(@collection)
          params[:q] ||= HashWithIndifferentAccess.new

          params[:q][:s] ||= 'created_at desc'
          @collection = super
          @search = @collection.ransack(params[:q])
          @collection = @search.result(distinct: true).
            page(params[:page]).
            per(params[:per_page] || Spree::StockEmailConfig::Config.per_page)

          @collection
        end
    end
  end
end
