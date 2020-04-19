class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  head "https://github.com/kilobyte/termrec.git"

  bottle do
    cellar :any
    sha256 "4c6ec1ae65b46494728ca14fdd9112474b8030d6d5d5b6abcd312b4ae6dff5ad" => :catalina
    sha256 "062bb1a65c337321569546e845048d3fb5912113bca87080530b72cd262fc8ff" => :mojave
    sha256 "61ffceeab4daf5feeeada49c1057ddafc8c5efb0c1561d7b8e1303462cba490b" => :high_sierra
    sha256 "b51ae0744fb22e3807841f852452c422f9117d53c83503b8b89ea7936ba700e7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/termrec", "--help"
  end
end
