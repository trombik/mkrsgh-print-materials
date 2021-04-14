# frozen_string_literal: true

require "pathname"
require "rqrcode"
require "uri"
require "net/http"
require "json"
require "fileutils"

def big_img_url(url_str)
  url = URI(url_str)
  file_name = url.path.split("/").last
  big_img_file_name = format("%s_2x.png", file_name.split(".").first)
  url.path = url.path.split("/")[0..-2].push(big_img_file_name).join("/")
  url
end

id = ARGV[0]
url_xkcd = URI(format("https://xkcd.com/%d", id))
url_json = URI(format("https://xkcd.com/%d/info.0.json", id))

dest = Pathname.pwd / id
dest.mkdir unless dest.exist?

res = Net::HTTP.get_response(url_json)
raise format("HTTP status (%<url>s): %<code>d", url: url_json, code: res.code) if res.code.to_i != 200

json = JSON.parse(res.body)
url_img = big_img_url(json["img"])
qrcode = RQRCode::QRCode.new(url_xkcd.to_s)
svg_file = Pathname.pwd / id / "qrcode.svg"

File.open(svg_file, "w+") do |f|
  f.write qrcode.as_svg
end

res = Net::HTTP.get_response(url_img)
raise format("HTTP status (%<url>s) : %<code>d", url: url_img, code: res.code) if res.code.to_i != 200

img_file = Pathname.pwd / id / url_img.path.split("/").last
File.open(img_file, "w+") do |f|
  f.write res.body
end

gimp_file = Pathname.pwd / id / "#{id}.xcf"
FileUtils.copy(Pathname.pwd / "template.xcf", gimp_file.to_s) unless gimp_file.exist?

puts format("url: %s", url_xkcd.to_s)
puts format("title: %s", json["title"])
puts format("alt: %s", json["alt"])
puts format("img url: %s", url_img.to_s)
puts format("img path: %s", img_file.to_s)
puts format("QR code path: %s", svg_file)
puts format("Image path: %s", img_file.to_s)
puts format("GIMP file path: %s", gimp_file.to_s)
