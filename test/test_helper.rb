require 'test/unit'
require File.dirname(__FILE__) + '/../lib/oauth'

begin
  # load redgreen unless running from within TextMate (in which case ANSI
  # color codes mess with the output)
  require 'redgreen' unless ENV['TM_CURRENT_LINE']
rescue LoadError
  nil
end

require File.dirname(__FILE__) + '/test_helper.rb'
require 'oauth/helper'

class TestOAuthHelper < Test::Unit::TestCase

  def test_parse_valid_header
    header ="OAuth "
    header << 'realm="http://example.com/method", '
    header << 'oauth_consumer_key="vince_clortho", '
    header << 'oauth_token="token_value", '
    header << 'oauth_signature_method="HMAC-SHA1", '
    header << 'oauth_signature="signature_here", '
    header << 'oauth_timestamp="1240004133", oauth_nonce="nonce", '
    header << 'oauth_version="1.0" '
    params = OAuth::Helper.parse_header(header)
    assert_equal "http://example.com/method", params['realm']
  end

  def test_parse_header_ill_formed
    header = "OAuth garbage"
    assert_raise OAuth::Problem do
      OAuth::Helper.parse_header(header)
    end
  end

  def test_parse_header_contains_equals
    header ="OAuth "
    header << 'realm="http://example.com/method", '
    header << 'oauth_consumer_key="vince_clortho", '
    header << 'oauth_token="token_value", '
    header << 'oauth_signature_method="HMAC-SHA1", '
    header << 'oauth_signature="signature_here_with_=", '
    header << 'oauth_timestamp="1240004133", oauth_nonce="nonce", '
    header << 'oauth_version="1.0" '
    assert_raise OAuth::Problem do
      OAuth::Helper.parse_header(header)
    end
  end

end
