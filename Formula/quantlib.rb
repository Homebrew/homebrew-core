class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.10/QuantLib-1.10.tar.gz"
  sha256 "30579ef4dd3912c4fc538b96d692394a9b8f06a2af5d03aaa630162e7f39d647"

  bottle do
    cellar :any
    sha256 "38e7ee5f1a8cdfb157342b01ff685b10fd2d8e3ce7621014862681691f29f72f" => :sierra
    sha256 "eedb2f82dc89b5624a817fd3114cb110e35389e665d386066c2f9800a24f62dc" => :el_capitan
    sha256 "58aca01c2d5ab537dbc0f58512a482a5662883617579d970260fd7d23b744e32" => :yosemite
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
