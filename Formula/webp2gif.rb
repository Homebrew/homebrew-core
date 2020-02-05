class Webp2gif < Formula
  desc "Convert animated webp to gif"
  homepage "https://github.com/elsonwx/webp2gif"
  url "https://github.com/elsonwx/webp2gif/archive/v0.1.tar.gz"
  sha256 "3c79adbb5637b4b20d2779a725c8b04941a8943c0b95142da40343ac8f077297"

  depends_on "imagemagick"
  depends_on "webp"

  def install
    bin.install "webp2gif"
  end

  test do
    system "webp2gif", "-v"
  end
end
