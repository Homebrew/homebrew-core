class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.13.tar.gz"
  sha256 "bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "989470332d705fa1a29be14b9e5ffea1eec2d6a1e214579fcd78918002dbc088" => :mojave
    sha256 "9b53ed5ffa25b50b9cafd16d06685982d5ff94bb804c685dcead4bee1826bfa5" => :high_sierra
    sha256 "79b525bb08faf52e69ec487047cdfa2492d015d78a64f241faf82a7f30afa0a5" => :sierra
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
