class WifiPass < Formula
  desc "Copy, QR encode or just get the password of current Wi-Fi connection"
  homepage "https://wifi-pass.ru"
  url "https://github.com/DaFuqtor/wifi-pass/archive/0.2.7.tar.gz"
  sha256 "c315d03693d707c47ba58e32f3bf9aaf0aa17f799b3838f68a1aa4f77ea9a5cc"
  head "https://github.com/DaFuqtor/wifi-pass.git"

  depends_on "qrencode" => :recommended

  def install
    bin.install "wifi-pass.sh" => "wifi-pass"
  end

  test do
    system "#{bin}/wifi-pass", "-V"
  end
end
