# frozen_string_literal: true

require "rqrcode"

def escape(string)
  # https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11
  string.gsub(/([;,":])/, '\\\\\1')
end

type = "WPA" # WEP or WPA or WPA2-EAP, or nopass
ssid = "makers"
password = ENV["WIFI_PASSWORD"]
escaped_url = format "WIFI:T:%<type>s;S:%<ssid>s;P:%<password>s;;",
                     type: escape(type),
                     ssid: escape(ssid),
                     password: escape(password)

qr = RQRCode::QRCode.new(escaped_url)
puts escaped_url
puts qr.as_ansi(quiet_zone_size: 5)
File.open("output.svg", "w+") do |f|
  f.write qr.as_svg
end
