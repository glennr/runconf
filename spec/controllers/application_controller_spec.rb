require 'spec_helper'

describe ApplicationController, 'current_user' do
  before(:each) do
    @db = stub_db
  end
  
  it "returns nil if not logged in" do
    controller.send(:current_user).should be_nil
  end
  
  it "loads the user with the id from the session" do
    session[:user_id] = '1'
    
    @db.should_receive(:load).with('1')
    
    controller.send(:current_user)
  end
  
  it "returns the user with the id from the session" do
    session[:user_id] = '1'
    user = stub(:iser)
    
    @db.stub(:load) {user}
    
    controller.send(:current_user).should == user
  end
end
