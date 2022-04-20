# frozen_string_literal: true

require "rqrcode"

url = ARGV[0]

qr = RQRCode::QRCode.new(url)
puts "URL: #{url}"
puts "File: output.svg"
puts qr.as_ansi(quiet_zone_size: 5)
File.open("output.svg", "w+") do |f|
  f.write qr.as_svg
end
