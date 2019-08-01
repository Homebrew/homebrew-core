class WifiPass < Formula
  desc "Copy, QR encode or just get the password of current Wi-Fi connection"
  homepage "https://wifi-pass.ru"
  url "https://github.com/DaFuqtor/wifi-pass/archive/0.2.7.tar.gz"
  head "https://github.com/DaFuqtor/wifi-pass.git"

  depends_on "qrencode" => :recommended

  def install
    bin.install "wifi-pass.sh" => "wifi-pass"
  end

  test do
    system "#{bin}/wifi-pass", "-V"
  end
end
