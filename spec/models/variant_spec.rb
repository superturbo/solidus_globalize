# frozen_string_literal: true

require 'spec_helper'

module Spree
  RSpec.describe Variant do
    let(:product) do
      Product.create!(
        name: 'globalize',
        price: 19.99,
        shipping_category: ShippingCategory.create!(name: 'a')
      )
    end

    let!(:variant) do
      described_class.create!(
        price: 19.99,
        product: product
      )
    end

    it 'fetches variant from product via translation table using ransack searches' do
      product_relation = Product.where(name: "globalize")
      variant_relation = described_class.joins(:product).merge(product_relation)
      described_class.includes(:product).ransack(translations_product_name_cont: 'globalize').result.to_a

      expect(variant_relation.last).to eq variant

      variants = described_class.includes(:product).ransack(translations_product_name_cont: 'globalize').result.to_a
      expect(variants.last).to eq variant
    end
  end
end
