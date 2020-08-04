class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.19.tar.gz"
  sha256 "4a5ff7d53ed5590944f2f0d6b96dd6fba041cc7601e25bc06b040257a455813a"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "bd0a2d672f32543a7b3f2fa859b64080a80499abea18d5dba84dc1c3fd1e08da" => :catalina
    sha256 "0b94a2a8fc76cdf2a86418f58ad95068341f8eedb98a9ff23546fc5d26310933" => :mojave
    sha256 "cb5b462641d2412e03a1f14ff1dd04fd49e11bd792fbc26431caec15713bd231" => :high_sierra
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
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
