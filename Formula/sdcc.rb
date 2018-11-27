class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.8.0/sdcc-src-3.8.0.tar.bz2"
  sha256 "b331668deb7bd832efd112052e5b0ed2313db641a922bd39280ba6d47adbbb21"
  head "http://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    sha256 "f4ab0af5aedcbcc75312e82ac1bf771fb4a9b1763d5b591b390a7e1dec523f32" => :mojave
    sha256 "bd962ac68c84d91e7768ba664369e94608fc39fca0085a6c7c696b96f0b3d7b6" => :high_sierra
    sha256 "cba250c36a04f486e966a0305420f67bf1c6005e60812d181c5894fd83991f45" => :sierra
  end

  depends_on "boost"
  depends_on "gputils"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
