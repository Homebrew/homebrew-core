class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.24.tar.gz"
  sha256 "736dfce1c7f521af3c4268c20a00b1cc2fd73a075ac08772aa8ae7810d36ae75"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83cc98d85a79486c40ffdf0ac192c43eddafedefd7f4635944a105d2900af419"
    sha256 cellar: :any,                 arm64_monterey: "8a9655601f5f8068663a939223a09a8d0470e6ae1c6ac73c63aad8539b950ee2"
    sha256 cellar: :any,                 arm64_big_sur:  "2c4080f8729cd011524be6f1a98b831a4edbcdb01b7abc803c589ec513bd60fb"
    sha256 cellar: :any,                 ventura:        "4ad131a30c37157baa27f1fbc7e316331b911b1707c45adab21c282ecb3fcd88"
    sha256 cellar: :any,                 monterey:       "2ed95e40a522601d37a26df3461e8e57171ec893a22dc21bf7d8a0d57eaee9e9"
    sha256 cellar: :any,                 big_sur:        "9d3b2b66e4f039e1d0511dc618a4b344ef0f3a90ce56b009cb502cf0d5bd474c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44241d943759c7ed42b593025134a6100b32909365940e2b12add6c0b15994cb"
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
