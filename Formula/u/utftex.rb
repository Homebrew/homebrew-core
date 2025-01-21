class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.25.tar.gz"
  sha256 "c50a44e33eba551526ff553c0af0bdd3f3a219d8ed60f11fcd9d7b30cd028af1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2600f08ffa67d205a11c72fb8edaa16bc5b25e0b1ef5b6a7d88e4dbee325d7cf"
    sha256 cellar: :any,                 arm64_sonoma:   "fcefa68f71397e48ca164144e5c78eacc458462b440ee3406379e8fc281b0b5e"
    sha256 cellar: :any,                 arm64_ventura:  "73dc2f438c0c50b6a443aa39a102520bd3f524bb2710729ecc8f2f908c7d497b"
    sha256 cellar: :any,                 arm64_monterey: "0810afd3a4807c93ecaaf60b948ebc54d669b5b199c7e34ef06e3962abdb5b05"
    sha256 cellar: :any,                 arm64_big_sur:  "2d42b33bf2be0776e1927f78d85e2a264b4a99cceaee85678c2f77d000863304"
    sha256 cellar: :any,                 sonoma:         "651d5493ded02c7aa424c3f2c9c0c53eea8508d2116fdd05fd43320319958651"
    sha256 cellar: :any,                 ventura:        "48ad8ca0fca773183943258a5000b80ac87a92fbcf643b5d5ae6308549f4679f"
    sha256 cellar: :any,                 monterey:       "4612a84d1625b774f4eea4e64c764dad77ca3b85e3fb80eadba71cb7febcc31e"
    sha256 cellar: :any,                 big_sur:        "972ff7102230d15986fd1cfe3b0275d47ca7c8fe99483e1009250cebcc96295a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "765d49e6c14eb18ed03f6898866b5f1ef95cf3e7e3355e1881e2a5c966b33719"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end
