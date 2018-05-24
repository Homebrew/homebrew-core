class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.13.tar.gz"
  sha256 "bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6"

  bottle do
    cellar :any
    sha256 "6ae61f9c2c8affd907c8093a5e589806f40a9919ed1fc9df74dd4da6226bae83" => :high_sierra
    sha256 "3695ab4acd323290ae5e1c48732ff7504e1640094764527de5fed3ae674909a3" => :sierra
    sha256 "ef23a29602b8cf7302a407fea1ead523b17c66b8e2c720eb120d7b8b49ed1ad9" => :el_capitan
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
