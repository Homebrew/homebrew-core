class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "https://www.scale2x.it/"
  url "https://github.com/amadvance/scale2x/releases/download/v4.0/scale2x-4.0.tar.gz"
  sha256 "996f2673206c73fb57f0f5d0e094d3774f595f7e7e80fcca8cc045e8b4ba6d32"

  bottle do
    cellar :any
    sha256 "83ab737ffb44b1b2913244a82c63d754057e79034bcf455d75b9150b630f85c7" => :catalina
    sha256 "da91fa8382839f9cf1b9d58b1e38b1d2f6d3cc1fef3cd0dce1481774397ebe35" => :mojave
    sha256 "2a3519bdbba8ff6caa1ca9b48d461866b8121dfd224a2c25da106087bb3cfd61" => :high_sierra
    sha256 "771e1b1ea660234e8bea89e774d0d802f7f1cb12c08e100cbb5b83d0a02a61ea" => :sierra
    sha256 "033e1adf0430ced99eef1b746842e9ca876b542f6fbd8f050e8f7c7e1b59f692" => :el_capitan
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}", "CPPFLAGS=-I/usr/include/malloc/"
    system "make", "install"
  end
end
