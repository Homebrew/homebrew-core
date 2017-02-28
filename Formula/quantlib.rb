class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.9.2/QuantLib-1.9.2.tar.gz"
  sha256 "9342bd7184a99a2769399a8738da58467804df36b582b389ffaaab5de22c019d"

  bottle do
    cellar :any
    sha256 "552c5fce38887d3ac72c825f8332f460c1e37c484911c318ec3da5c5c6f4ddc6" => :sierra
    sha256 "ac1c6554d50f1296b7554c452d0433dd363a373f62167332c763e8c3d34bd14e" => :el_capitan
    sha256 "41152596ea9d392ab65ee4e61007b3eb54328a0787b0cd2df6c5ca7091d65219" => :yosemite
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11
  option "with-intraday", "Enable intraday components to dates"

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
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
