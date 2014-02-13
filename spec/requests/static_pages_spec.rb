require 'spec_helper'

describe "Static Pages" do
  subject { page }
  describe "Top page" do
    before { visit root_path }

    it { should have_content('AIDS Research Center HLA Project') }
    it { should have_title("ARC-HLA | Top") }
    it { should have_content('Top') }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('AIDS Research Center HLA Project') }
    it { should have_content('Help') }
    it { should have_title("ARC-HLA | Help") }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('AIDS Research Center HLA Project') }
    it { should have_content('About Us') }
    it { should have_title("ARC-HLA | About") }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('AIDS Research Center HLA Project') }
    it { should have_content('Contact Us') }
    it { should have_title("ARC-HLA | Contact") }
  end
end
