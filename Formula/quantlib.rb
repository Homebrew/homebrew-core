class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.21.tar.gz"
  sha256 "3d3296fb13f822de6b980692604e2b1ba0d1b45e0e32d67d80b4cc9725b87d1b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "bb5ff2517d357ea2e826a631c38c1ba1b2b8da2ffe55c29b3769977d6d657405" => :big_sur
    sha256 "5441d1bce82caaf8623d369f8b9f493d69c55a4cf95a12786db255947f9766cb" => :arm64_big_sur
    sha256 "61d144264132e25c31f347dbdf3c44595be790e851d671159ffaa3d6027b0f04" => :catalina
    sha256 "0fb3b38c1c385bdfd8bbe930c3eb64b8b9d3cf4451715325e0f3717c9ade0b69" => :mojave
    sha256 "d6b3bda389b8d94685f47611d4abfa578d9b2166a2e9603ff07a6961a99f70c4" => :high_sierra
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
