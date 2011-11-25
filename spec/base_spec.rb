require 'spec_helper'

describe Mailgun::Base do

  before :each do
    @mailgun = Mailgun({:api_key => "some-junk-string"})

    @sample_options = {
      :api_key 	    => Mailgun.api_key,
      :api_version  => Mailgun.api_version,
      :protocol     => Mailgun.protocol,
      :mailgun_host => Mailgun.mailgun_host
    }
  end

  describe "Mailgun.new" do
    it "Mailgun() method should return a new Mailgun object" do
      @mailgun.should be_kind_of(Mailgun::Base)
    end

    it "should use https by default" do
      Mailgun.protocol.should == "https"
    end
  end


  
  describe "resources" do
    
    it "Mailgun#mailboxes should return an instance of Mailgun::Mailbox" do
      @mailgun.mailboxes.should be_kind_of(Mailgun::Mailbox)
    end

    it "Mailgun#routes should return an instance of Mailgun::Route" do
      @mailgun.routes.should be_kind_of(Mailgun::Route)
    end
  end


  
  describe "internal helper methods" do

    describe "Mailgun#base_url" do
      it "should return https url if use_https is true" do
      @mailgun.base_url.should == "https://api:#{Mailgun.api_key}@#{Mailgun.mailgun_host}/#{Mailgun.api_version}"
      end
    end

    describe "Mailgun.submit" do
      it "should send method and arguments to RestClient" do
        RestClient.should_receive(:test_method)
          .with({:arg1=>"val1"},{})
          .and_return({})
        Mailgun.submit :test_method, :arg1=>"val1"
      end
    end
    
  end

  describe "configuration" do
    before(:each) do
      Mailgun.configure do |c|
        c.api_key = 'some-api-key'
        c.api_version = 'v2'
        c.protocol = 'https'
        c.mailgun_host = 'api.mailgun.net'
        c.test_mode = false
        c.domain = 'some-domain'
      end
    end

    it "allows me to set my API key easily" do
      Mailgun.api_key.should eql 'some-api-key'
    end

    it "the api_version attribute" do
      Mailgun.api_version.should eql 'v2'
    end

    it "the protocol attribute" do
      Mailgun.protocol.should eql 'https'
    end
    
    it "the mailgun_host attribute" do
      Mailgun.mailgun_host.should eql 'api.mailgun.net'
    end
    it "the test_mode attribute" do
      Mailgun.test_mode.should eql false
    end

    it "allows me to set my domain easily" do
      Mailgun.domain.should eql 'some-domain'
    end
  end
end
