require File.dirname(__FILE__) + '/test_helper'

class WeewarSpyErrorsTest < Test::Unit::TestCase

  context "Error Signaling Tests" do

    setup do
      @params = { :server => 'weewar.com', :username => 'mriffe', :api_key => '7q3j9Eqxd4xJGqSgjB6gbQAUq' }
    end

    context "Missing Configuration" do

      should "complain about missing server" do
        @params.delete(:server)
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
        @params[:server] = ''
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
        @params[:server] = ' '
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
      end

      should "complain about missing username" do
        @params.delete(:username)
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
        @params[:username] = ''
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
        @params[:username] = ' '
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
      end

      should "complain about missing api_key" do
        @params.delete(:api_key)
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
        @params[:api_key] = ''
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
        @params[:api_key] = ' '
        assert_raise(RuntimeError) { WeewarSpy::API.init(@params) }
      end

    end

    context "Incorect Configuration" do

      should "complain about incorrect server" do
        @params[:server] = 'server'
        WeewarSpy::API.init(@params)
        error = assert_raise(SocketError) { WeewarSpy::API.get("/user/1") }
        assert_match(/getaddrinfo.*not known/, error.message)
      end

      should "complain about incorrect username" do
        WeewarSpy::API.init(@params)
        error = assert_raise(WWW::Mechanize::ResponseCodeError) { WeewarSpy::API.get("/user/-1") }
        assert_match(/404|Net::HTTPNotFound/, error.message)
      end

      should "complain about incorrect api_key" do
        @params[:api_key] = 'apiToken'
        WeewarSpy::API.init(@params)
        error = assert_raise(WWW::Mechanize::ResponseCodeError) { WeewarSpy::API.get("/headquarters") }
        assert_match(/401|Net::HTTPUnauthorized/, error.message)
      end

    end

    context "Bad Requests" do

      should "complain about missing player" do
        WeewarSpy::API.init(@params)
        error = assert_raise(WWW::Mechanize::ResponseCodeError) { WeewarSpy::API.get("/user/insanity_rocks") }
        assert_match(/404|Net::HTTPNotFound/, error.message)
      end

      should "complain aobut missing game" do
        WeewarSpy::API.init(@params)
        error = assert_raise(WWW::Mechanize::ResponseCodeError) { WeewarSpy::API.get("/game/-1") }
        assert_match(/404|Net::HTTPNotFound/, error.message)
      end

    end

  end
  
end
