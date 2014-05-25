# encoding: utf-8

module StringHelper
  def sanitize_str(str)
    # replace &nbsp; with space
    # get rid of newline
    str.gsub("\xC2\xA0", " ").gsub("\n", "").gsub("\r", "").squeeze(" ").strip
  end
end