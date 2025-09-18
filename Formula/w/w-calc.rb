class WCalc < Formula
  desc "Very capable calculator"
  homepage "https://w-calc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/w-calc/Wcalc/2.5/wcalc-2.5.tar.bz2"
  sha256 "0e2c17c20f935328dcdc6cb4c06250a6732f9ee78adf7a55c01133960d6d28ee"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ea670dd67545b11daf3baa92b75881e4abdafa8456c69876ba800b24777e6d7a"
    sha256 cellar: :any,                 arm64_sequoia:  "6e58f6ee9e2c2996498fbdefc112993bf9462421d1523e46360eebd7fbb975c8"
    sha256 cellar: :any,                 arm64_sonoma:   "22c9fbdad127cb9d4a7bb8cdf77a9a42a07e3849e222e16004ceff2b9a913b97"
    sha256 cellar: :any,                 arm64_ventura:  "2140a067af2aa1e613e7dfc8ec7ef33ff4650f4519b4e989ad7d36d00636ffa2"
    sha256 cellar: :any,                 arm64_monterey: "710c2684d517f0f0f522008f77b8e3cced2aa51e5e7f5a42d1c9441ad40c24db"
    sha256 cellar: :any,                 arm64_big_sur:  "0213a099bdf4e642145fba3fa6d034edaa5d5c628259cd175f271b3aa5b35ff8"
    sha256 cellar: :any,                 sonoma:         "522929c224331663ad3fb955b1a0db32fc2e2faf3e292235d81662a09bc53c4d"
    sha256 cellar: :any,                 ventura:        "5b810eb4cf6254d48f1d6c6c5c582db14cec2b7cd432ba052746b99c2434b0c7"
    sha256 cellar: :any,                 monterey:       "efd668bc2f63e75a53063b66b9efca1cffea5eb1ea345ad7f72f6e1fcc805dd0"
    sha256 cellar: :any,                 big_sur:        "27705bfedd11e7181437ecfa3518ed5ca3a10cf9bbb81c6dd7f331080a476b9a"
    sha256 cellar: :any,                 catalina:       "dfde02c6213c6eeeecaeae55d7ecaa7620ab5c86f346f9242c82899802901b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77cd92e140bbedd38f7dcfa8827d03b0d829fc97c6188314ce7d647ed969cbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739d3b28f0cfb194a6965fd522a335859e9f5611faf0f6bafbd8577f5fb823de"
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    # Workaround for build with newer clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "4", shell_output("#{bin}/wcalc 2+2")
  end
end
