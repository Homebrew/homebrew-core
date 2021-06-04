class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.22/QuantLib-1.22.tar.gz"
  sha256 "85c81816f689f458596dd7073e4da8fd7f596c1e4c8ada81a6300389a39588af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "214a9ab699f70d2ebb04b657765226d2d1fed652b58569ad8c4313ff44bd8d9f"
    sha256 cellar: :any, big_sur:       "603406285fa983b9d1554e9d63ac32aace6411ffe25c4159dba099d9e1a7db02"
    sha256 cellar: :any, catalina:      "90c93befaffe6c8a9ef0375d9973cebc308efa015842c30e7230797586efb8c6"
    sha256 cellar: :any, mojave:        "cd8bf24144bb637bffc30582a3bea35a1c4a14aee394ae355a541d414e88484f"
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
