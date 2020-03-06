class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.0.0/sdcc-src-4.0.0.tar.bz2"
  sha256 "489180806fc20a3911ba4cf5ccaf1875b68910d7aed3f401bbd0695b0bef4e10"
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    sha256 "91714d5a605eeff62a35e63aac856be74e35016302fa13dab181bb5422ebe7aa" => :catalina
    sha256 "a4cfec7484f490988b439426b05310c4ddcd155a16f6d95967b0265e62b82a6c" => :mojave
    sha256 "79f6440540864bb4fdbe3a30619c3dec35e5daa9ae012c979882e9e95c27d088" => :high_sierra
    sha256 "129e06c6cab2f160d8eb9da70030443d9ffb783bd346be52a05b1af4b95d22ba" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
