require 'spec_helper'
require 'action_view'
# require 'active_support'

RSpec.describe NextInPlace::ViewHelpers do
  with_model :product do
    table do |t|
      t.string :name
      t.string :category
      t.string :description
      t.boolean :status
      t.integer :sku
      t.decimal :fob_price
      t.timestamps null: false
    end
  end

  include NextInPlace::ViewHelpers
  include ActionView::Helpers
  include ActionView::Context

  let(:product) { Product.new(name: 'test', sku: 555, category: 'craft beer', fob_price: '27.50') }

  describe '#next_in_place' do
    it 'generates an span tag if type is not defined' do
      expect(next_in_place(product, :sku)).to match 'data-nip-type="input"'
    end

    it 'generates an correct type of tag when type is defined' do
      expect(next_in_place(product, :sku, type: 'textarea')).to match 'data-nip-type="textarea"'
    end

    it 'returns correct class name' do
      expected = "nip-#{product.id}-product"
      expect(next_in_place(product, :sku, class: 'test-class')).to include(expected)
    end

    it 'returns correct id' do
      expect(next_in_place(product, :sku, class: 'test-class')).to include("nip-#{product.id}-product")
    end

    it 'returns correct attribute name' do
      expect(next_in_place(product, :sku, class: 'test-class')).to include('data-nip-attribute="sku"')
    end

    it 'returns correct object name' do
      expect(next_in_place(product, :sku, class: 'test-class')).to include('data-nip-object="product"')
    end

    it 'sets the original_value attribute correctly' do
      expect(next_in_place(product, :sku, class: 'test-class')).to include('data-nip-original-value="555"')
    end

    it 'sets the value attribute correctly' do
      expect(next_in_place(product, :sku, class: 'test-class')).to include('data-nip-value="555"')
    end

    describe 'collection option' do
      it 'correctly sets the nip-collection attribute when values are provided' do
        expect(next_in_place(product, :sku, class: 'test-class', collection: { "pens": 'pens', "pencils": 'pencils' })).to match(`data-nip-collection="{"pens": "pens", "pencils": "pencils"}"`)
      end

      it 'does not set the nip-collection attribute if no values are provided' do
        expect(next_in_place(product, :sku, class: 'test-class')).not_to include('data-nip-collection=')
      end
    end

    describe 'html_attrs option' do
      it 'correctly sets the nip-html-attrs are present' do
        expect(next_in_place(product, :sku, class: 'test-class', html_attrs: { rows: 6, columns: 4 })).to include(`data-nip-html-attrs="{"rows": "6", "columns": "4"}"`)
      end

      it 'does not set the nip-html-attrs attribute when not present' do
        expect(next_in_place(product, :sku, class: 'test-class')).not_to include('data-nip-attrs=')
      end
    end

    describe 'display value' do
      context 'when display_with attribute specified' do
        it 'correctly formats the display value using a view helper' do
          expect(next_in_place(product, :fob_price, class: 'test-class', display_with: 'number_to_currency')).to include '$27.50'
        end

        it 'correctly formats the display value using a model method' do
          dbl = double('product', id: 2, fob_price: '27.50')
          allow(dbl).to receive(:number_with_dashes).and_return('-27.50-')
          expect(next_in_place(dbl, :fob_price, class: 'test-class', display_with: 'number_with_dashes')).to include '-27.50-'
        end

        it 'sets the value attribute correctly' do
          expect(next_in_place(product, :fob_price, class: 'test-class', display_with: 'number_to_currency')).to include(`data-nip-value="27.50"`)
        end

        it 'sets the orignal value attribute correctly' do
          expect(next_in_place(product, :fob_price, class: 'test-class', display_with: 'number_to_currency')).to include(`data-nip-original-value="27.50"`)
        end
      end

      context 'when display_with NOT specified' do
        it 'returns correct display value' do
          expect(next_in_place(product, :fob_price)).to match '27.5'
        end
      end
    end
  end
end
