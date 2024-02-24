RSpec.describe "Admin", type: :request do
  context "while signed in as a super admin" do
    before do
      sign_in(@super_admin_no_org)
    end

    it "allows a user to load the dashboard" do
      get admin_dashboard_path
      expect(response).to be_successful
    end

    it "shows a logout button" do
      get admin_dashboard_path
      expect(response.body).to match(/log out/im)
    end

    context "when the user has a name" do
      let!(:user_with_name) { create(:user, name: "John Doe", email: "john@example.com") }

      it "displays the user's name" do
        get admin_dashboard_path
        expect(response.body).to include("John Doe")
        expect(response.body).not_to include("john@example.com")
      end
    end

    context "when the user does not have a name" do
      let!(:user_without_name) { create(:user, name: nil, email: "noname@example.com") }

      it "displays the user's email" do
        get admin_dashboard_path
        expect(response.body).to include("noname@example.com")
      end
    end
  end
  context "while signed in as a non-super-admin" do
    it "disallows dashboard access, redirecting to the normal dashboard" do
      [@organization_admin, @user].each do |u|
        sign_in(u)
        get admin_dashboard_path
        expect(response).to redirect_to(dashboard_path)
        expect(response).to have_error
      end
    end
  end
end
