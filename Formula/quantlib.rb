class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.27.1/QuantLib-1.27.1.tar.gz"
  sha256 "ab5e3620e1556b025a4e7a80a9e59c5fc27ae2c7a0e850b9698ad22d0c553d18"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "457b49d51ffe5cfcb196622711f5253d17b9777858c87959d2b95b776507eb5c"
    sha256 cellar: :any,                 arm64_big_sur:  "ea6a8896bb409eb981b82dd9a919fe3dada9736fa9b76025b696f6652931c186"
    sha256 cellar: :any,                 monterey:       "5c7e8e598634bc241aad3eb20d83a6a38a245bd0cc1cb1840dbb02862683dfe3"
    sha256 cellar: :any,                 big_sur:        "6f2839248d3657c8ba1fbfe30af4e5e6ad2c09ef9421c62d60724d7c0245ffaa"
    sha256 cellar: :any,                 catalina:       "1848b6d5c425938d9dcc4b695963e114c829eccc5cdb81a3f4dad9f5c36e31fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2f3affe771d0acc0a9ca00ddb255894e56ac0c7969d4610b6955a5a2434d1b"
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
