require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropsot" do
        expect { click_button "Post" }.should_not change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.should change(Micropost, :count).by(1)
      end
    end
  end    

#chapter 10 exercise 2
  describe "pagination" do

    before do 
      60.times { FactoryGirl.create(:micropost, user: user, content: "xy") }
      #visit user_path(user) // works as well
      visit root_path
    end

    it { should have_selector('div.pagination') }

    it "should list every feed" do
      user.microposts.paginate(page: 1).each do |feed|
        page.should have_selector('li', text: feed.content)
      end
    end
  end
#/end chapter 10 exercise 2 

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end
    end
  end

# chapter 10 exercise 4
  describe "micrpost cant be deleted by another user" do
    let(:user2) { FactoryGirl.create(:user, name: "ii", email: "oo@oo.com") }

    describe "not by user 1" do
      before { visit user_path(user2) }

      it "should not possible" do
        page.should_not have_link "delete"
      end
    end
  end
end
