class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"
  license "ISC"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbcb5b7fc991956788025ab520c25494e0f7c324c32708b4b73512b5d34e7763"
    sha256 cellar: :any,                 arm64_monterey: "4ae4e51389a9abf20d308286994953e52a74a8dc1d9d66a68d36eb168d980f8f"
    sha256 cellar: :any,                 arm64_big_sur:  "62112cc971b1d4d2d8c13fa77b8a58facd580eff962ef11caabe17c984d92837"
    sha256 cellar: :any,                 ventura:        "359751f5df2a82e80c54bb43431e590a0d54664191a5f5d0e07086cc37224351"
    sha256 cellar: :any,                 monterey:       "e7600254ecec3dcce2242b572a846e3c4b1bde4d8901f4e4b82f5beea68e8d32"
    sha256 cellar: :any,                 big_sur:        "a077017df7d61abe471103ae6e7dd8ac7a141d1f1504e1d8466eee1d5d126d22"
    sha256 cellar: :any,                 catalina:       "2a2365ffef9a676267001e51e9330a8c4fb52c9f70602b7bd6196fc581f85add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b53c12b60d9b1dbe457e49429351adec592b9cbd2dec004fd5131fd4ae2f739"
  end

  depends_on "jpeg-turbo"
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
