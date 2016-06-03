class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "http://traildb.io"
  url "https://github.com/traildb/traildb/archive/0.5.tar.gz"
  sha256 "4d1b61cc7068ec3313fe6322fc366a996c9d357dd3edf667dd33f0ab2c103271"

  depends_on "libarchive"
  depends_on "pkg-config" => :build

  # only required because we run autoreconf for judy
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    ENV["PREFIX"] = prefix

    resource("judy").stage do
      # Only build library, we don't care about tools, docs.
      # This also requires running autoreconf
      inreplace "Makefile.am", "src tool doc test", "src"
      system "autoreconf", "-fiv"

      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--prefix=#{prefix}"
      system "make", "-j1", "install"
    end

    ENV["CFLAGS"] = "-I#{prefix}/include"
    ENV["LDFLAGS"] = "-L#{prefix}/lib"
    system "./waf", "configure", "install"
  end

  test do
    (testpath/"in.csv").write("1234 1234\n")
    system "#{bin}/tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
