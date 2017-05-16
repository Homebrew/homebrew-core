class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.10/QuantLib-1.10.tar.gz"
  sha256 "30579ef4dd3912c4fc538b96d692394a9b8f06a2af5d03aaa630162e7f39d647"

  bottle do
    cellar :any
    sha256 "7220cef1873bde66838a6297f307956fc5d19cab4786a924ed8938c404b9d785" => :sierra
    sha256 "e281a0dad38c325aad8594fe5d99e225c1a6ab6f0e0c3198e5a08508042abe4a" => :el_capitan
    sha256 "dc77bc2d82220ae85d2b96d853b182754d17e92b544c8b69711ae325163d2dcc" => :yosemite
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
