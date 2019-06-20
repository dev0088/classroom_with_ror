# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    it "returns success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    it "redirects to the dashboard if the user is already logged in" do
      sign_in_as(create(:user))

      get :home
      expect(response).to redirect_to(organizations_path)
    end
  end
end

RSpec.describe PagesController, type: :controller do
  describe "GET #help" do
    it "returns success", :focus => true do
      expected_pages = [
        "create-group-assignments",
        "probot-settings",
      ]
      expected_pages.each do |help_page|
        get :help, :params => { :article_name => help_page }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
