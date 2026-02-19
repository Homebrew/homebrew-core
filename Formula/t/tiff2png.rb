class Tiff2png < Formula
  desc "TIFF to PNG converter"
  homepage "http://www.libpng.org/pub/png/apps/tiff2png.html"
  url "https://github.com/rillian/tiff2png/archive/refs/tags/v0.92.tar.gz"
  sha256 "64e746560b775c3bd90f53f1b9e482f793d80ea6e7f5d90ce92645fd1cd27e4a"
  license "ISC"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cc94154a902618ac2619cec04577a4dc5532ed13adff9506fffd4180521d5b78"
    sha256 cellar: :any,                 arm64_sequoia: "52071a61b3b8a6a78b8d48025aabc0ad60cf8c4945ab879bb44e884b36fc56db"
    sha256 cellar: :any,                 arm64_sonoma:  "0dacffb8b0bad6b6e7ef4493a2e97ac17198fdf09f78918d8b8ae3a07f47bd5e"
    sha256 cellar: :any,                 sonoma:        "062634cd7eafd6689cce9dad0335fa49edee9523df3ad90bf0b1f27c9637ec18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421b0c9de1f281a0bc9656c60e53dfafa075bc9e398c5d20e6063d8f7eaf823a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26cc20cd78f76377d345f2c3517b66f069319067eeeb83d72ce0b6f74a122282"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    bin.mkpath
    system "make", "INSTALL=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    system bin/"tiff2png", test_fixtures("test.tiff")
  end
end
