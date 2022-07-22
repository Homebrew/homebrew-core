class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.27/QuantLib-1.27.tar.gz"
  sha256 "5c2cab0f9bbcdcd3ca1b45d7930b3ab7e120857587b6f61c463b2a012a8bc6a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a08f452a0a811f68bd27b3d252c2672d220689c5217129033f7ba39486e9aa37"
    sha256 cellar: :any,                 arm64_big_sur:  "798ffd2fa1f0242bcba454b48a2c47a17e8b5b73d1646053ef921a92a4798d46"
    sha256 cellar: :any,                 monterey:       "04e8b78c7197abd6abd768f0458f66724132d34c23435e3de75721c175ba8acb"
    sha256 cellar: :any,                 big_sur:        "c029ac861b197c0aaa785740ab5ecedc96795fc7d51cd00f4455701e16beda70"
    sha256 cellar: :any,                 catalina:       "f3df1965445ffad03af80fae6729d5eabbb31d8e4085717cee751a42aa46d6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3473e5d2ad695ae650887aff91cab32c5937f0d533989d76c2a46ccd916ff4f5"
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
