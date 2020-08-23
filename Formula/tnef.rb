class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.18.tar.gz"
  sha256 "fa56dd08649f51b173017911cae277dc4b2c98211721c2a60708bf1d28839922"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff92eb820b2efae9e87e42491a590601f400160f27ea2804b176b02b1648be66" => :catalina
    sha256 "2700f31ebcc1e2ba9219d6b6ac040846eba21ccc25baca4fea8b7d630b6673d2" => :mojave
    sha256 "842ba6bbe666302bd39c1cf7d29caa7d5180c20757b8dfe91b99d3fe1d3da841" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tnef", "--version"
  end
end
