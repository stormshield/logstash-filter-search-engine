# encoding: utf-8

# Utility class
class Utils

  # Sanitize a UTF 8 string : remove invalid characters
  def self.removeInvalidChars(str)
    if(str && !str.valid_encoding?)
      return str.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: "")
    end
    return str
  end

end
