class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.16.tar.gz"
  sha256 "204ad5822259f9a9146eaf660f0b756100604e3adb85c501d41d201bf09dec94"

  bottle do
    cellar :any
    sha256 "7129e1dfd9c0496f90c882c1c898d57c57d4b74f8b1071d2e209f28098994479" => :mojave
    sha256 "fd1eb38da9415f4025725a193b735e773c05e1434f5c41df15f2ca7deca1f000" => :high_sierra
    sha256 "b10c508900dfdf97639dbf4613619af92f6d7af6c85eabf19df010687c2aa080" => :sierra
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
