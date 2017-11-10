module Spree
  module Admin
    module StockEmailsHelper
      def variant_extended_name(variant)
        vot = variant_options_text(variant)
        if vot.blank?
          variant.name
        else
          "#{variant.name} (#{vot})"
        end
      end

      def variant_options_text(variant)
        variant.option_values.map { |ov| "#{ov.presentation}" }.to_sentence({:words_connector => ", ", :two_words_connector => ", "})
      end
    end
  end
end
