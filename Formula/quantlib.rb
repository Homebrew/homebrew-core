class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.10.1/QuantLib-1.10.1.tar.gz"
  sha256 "bcb88be6a485ae62bb00027c180294d2af0dbea252e4f76e1284e4af3a9c4432"

  bottle do
    cellar :any
    sha256 "1e30e8f6abaf298cf8befeca8ebf44def35ec1d339b772915012db48ab18c699" => :sierra
    sha256 "8becc7366c6d4eb3e7f18db5f6e266f102bf4c9da0e512b84c165c490761d7dc" => :el_capitan
    sha256 "1201256675b6cb4d0be3272eaa7a283032c495393abe539132185b6f2ac54a12" => :yosemite
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-intraday", "Enable intraday components to dates"

  depends_on "boost"

  def install
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      args = []
      args << "--enable-intraday" if build.with? "intraday"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            *args

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
