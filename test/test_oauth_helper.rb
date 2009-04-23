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
    assert_equal "vince_clortho", params['oauth_consumer_key']
    assert_equal "token_value", params['oauth_token']
    assert_equal "HMAC-SHA1", params['oauth_signature_method']
    assert_equal "signature_here", params['oauth_signature']
    assert_equal "1240004133", params['oauth_timestamp']
    assert_equal "nonce", params['oauth_nonce']
    assert_equal "1.0", params['oauth_version']
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
