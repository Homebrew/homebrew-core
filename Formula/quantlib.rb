class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.16.tar.gz"
  sha256 "204ad5822259f9a9146eaf660f0b756100604e3adb85c501d41d201bf09dec94"

  bottle do
    cellar :any
    sha256 "2c0d5709ac2d0150d9a80e98037e065fb427754c8a5ffc73657b436e1833079e" => :catalina
    sha256 "39702a332dbff419f3d34c12a19ee378a369e8a20400d4a35b16370916c2e22f" => :mojave
    sha256 "c39c206cb0c0b96b6dd218a50020c683095362216c06ad009fea4210a53a0b0c" => :high_sierra
    sha256 "d7589436bfcb0ce268bb25db660500440cb299fd751e32bfbc21485e54b57a98" => :sierra
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
