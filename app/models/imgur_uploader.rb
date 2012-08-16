class ImgurUploader
  class << self
    def cgi_escape(str)
      str.gsub(/([^ a-zA-Z0-9_.-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end.tr(' ', '+')
    end

    def uploadImage(image)
      imageData = UIImagePNGRepresentation(image)     
      imageStr = cgi_escape(imageData.base64Encoding)
      data = {key:'', image:imageStr}
      original_url = ""
      BubbleWrap::HTTP.post("http://api.imgur.com/2/upload.json", {payload: data}) do |response|
        if response.ok?
         res = response.body.to_str
         json_response = BubbleWrap::JSON.parse(res)
         original_url = json_response["original"]
        end
      end
      original_url
    end
  end

end
