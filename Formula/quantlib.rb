class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.12/QuantLib-1.12.tar.gz"
  sha256 "fcf82734fa065a81141a67f0fe185d80166e60199dd7143ac5847af4ce9a36ed"

  bottle do
    cellar :any
    sha256 "75ef28ccc5ff154a4f388e5917bb5737f3d900f48f28939554dfc4a5c7584cf1" => :high_sierra
    sha256 "ac4a92afba00d9385459994459ddcfedc015b20f9597ce717e7c4353f66a3bd4" => :sierra
    sha256 "b5e589e9ed41c03a5fe65cee7d525759847ed8dda6cb5342c674574e8e91501b" => :el_capitan
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
