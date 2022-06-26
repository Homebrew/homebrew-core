class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "60208bd0d504537d8c865a88b74a019f407fb941aba58f211a84a13292cbbf07"
    sha256 cellar: :any,                 arm64_big_sur:  "2afce14eed0478fdf2cdfdddf4d69264b91915f19081f5ea57073d9a7a2076e9"
    sha256 cellar: :any,                 monterey:       "6c4ddd504062c8cd655fc347cf51b188870855c311affb27b1c605109aa5d597"
    sha256 cellar: :any,                 big_sur:        "6001968757ed9c3dd7f67c8d4f53cb57d3d8ae67de0ab995167bbf761e4a26a6"
    sha256 cellar: :any,                 catalina:       "7589c830ef81bd43dd0bd3d1ba65483965701dfff8f7c4d8760951f0cf47c378"
    sha256 cellar: :any,                 mojave:         "e8cf86b68e703c8c5c6fc0f6e9ffee0e2823a103cb685d4a33d21fb626a96439"
    sha256 cellar: :any,                 high_sierra:    "e20cc758aab7de1c1e9d286e469a444fe9e384bcffe472ec6a52c06b31131ac4"
    sha256 cellar: :any,                 sierra:         "19951f2ec63fa3c77a43fe2c2444251686ad4fcc1038fbeeb8873fcd528d8954"
    sha256 cellar: :any,                 el_capitan:     "43f0afaca7d61a7f55489260deb233c0a35619d3101d362f80dc7a765a877599"
    sha256 cellar: :any,                 yosemite:       "bf11412cac81c328f8e8de50c182be049696d053ac900b56302685e858562811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298c637d45b059fd40dc321a5c3fe2d099cd5a91d6eca45c5272e96e3badf240"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    bin.mkpath
    system "make", "INSTALL=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    system "#{bin}/tiff2png", test_fixtures("test.tiff")
  end
end
