class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.11/QuantLib-1.11.tar.gz"
  sha256 "ef420d584233cb83a28245315dec2a1edda5fdbdf7a655fee7afc83ba5c0dee8"

  bottle do
    cellar :any
    sha256 "736ffa72d7348508efdd340e12855c646df9b27d423aa895c3a8e4abcd28b7cc" => :high_sierra
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
