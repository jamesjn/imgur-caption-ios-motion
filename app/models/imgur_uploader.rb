class ImgurUploader
  class << self
    def cgi_escape(str)
      str.gsub(/([^ a-zA-Z0-9_.-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end.tr(' ', '+')
    end

    def uploadImage(image, list, controller)
      imageData = UIImageJPEGRepresentation(image, 0.5)     
      imageStr = cgi_escape(imageData.base64Encoding)
      data = {key: ApiKeys::IMGUR_KEY, image:imageStr}
      original_url = ""
      BubbleWrap::HTTP.post("http://api.imgur.com/2/upload.json", {payload: data}) do |response|
        if response.ok?
          res = response.body.to_str
          json_response = BubbleWrap::JSON.parse(res)
          original_url = json_response["upload"]["links"]["original"]
          small_url = json_response["upload"]["links"]["small_square"]
          controller.activity_indicator.stopAnimating
          list.images ||= []
          list.images << {:original_url => original_url, :small_url => small_url, :time => Time.now.to_i}
        end
      end
      original_url
    end
  end

end

#for testing
#
#class Response
#  attr_accessor :body
#  def ok?
#    true
#  end
#end
#
#class BubbleWrap::HTTP
#  def self.post url, options
#    response = ::Response.new
#    response.body = '{"upload":{"links":{"original":"http://i.imgur.com/yIJ00.jpg","imgur_page":"http://imgur.com/yIJ00","delete_page":"http://imgur.com/delete/TngVYOU4146xQFe","small_square":"http://i.imgur.com/yIJ00s.jpg","large_thumbnail":"http://i.imgur.com/yIJ00l.jpg"}}}'
#    yield(response)
#  end
#end
#
#    '{"upload":{"image":{"name":null,"title":null,"caption":null,"hash":"yIJ00","deletehash":"TngVYOU4146xQFe","datetime":"2012-09-03 22:59:27","type":"image/jpeg","animated":"false","width":480,"height":640,"size":37600,"views":0,"bandwidth":0},"links":}}}'
