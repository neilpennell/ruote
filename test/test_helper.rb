
#
# testing ruote
#
# since Mon Oct  9 22:19:44 JST 2006
#

require File.join(File.dirname(__FILE__), 'path_helper')

require 'test/unit'
require 'rubygems'


def require_json
  begin
    require 'yajl'
  rescue LoadError
    require 'json'
  end
end

