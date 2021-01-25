class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.21.tar.gz"
  sha256 "3d3296fb13f822de6b980692604e2b1ba0d1b45e0e32d67d80b4cc9725b87d1b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "d5e6c206260e8ef5e297e464dd45979fe56bdaa938c75a071f70fce97b1b391e" => :big_sur
    sha256 "b930efbd942abbb5f9317d3d15fc0ca6a551cc3f7d5c3eb7cdb77464770d5ae0" => :arm64_big_sur
    sha256 "18dd1cc854b50e811fec338ba31f7ea3d6aacf80a4f0c1f90c8d8db8d891b2b7" => :catalina
    sha256 "03c142589e975e9ba78966cd9f813fc77ae22aefea1049b43f3e7406cd090193" => :mojave
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
