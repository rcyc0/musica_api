# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Artists', type: :request do
  describe 'GET /artists' do
    it 'works! (now write some real specs)' do
      get artists_path
      expect(response).to have_http_status(:ok)
    end
  end
end
