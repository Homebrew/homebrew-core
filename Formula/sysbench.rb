class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.13.tar.gz"
  sha256 "32082772dbb1a3c0ab7899b6678817f1386f2e9ffdd0da005ca59f904dafc12c"

  bottle do
    sha256 "76fe69db22ac57b2876b47f3209c153b9f5765f0eda86a6b512d29c3f467df33" => :high_sierra
    sha256 "633a4e7470a0db791ccdc4e6e070b188776df80814cf80919eb9dc31d5e3a440" => :sierra
    sha256 "19c84895f37d3b8e63917b586bc453385a27ca740404a4b831a1aa1734cbb63e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on "mysql" => :recommended

  def install
    system "./autogen.sh"

    args = ["--prefix=#{prefix}"]
    if build.with? "mysql"
      args << "--with-mysql"
    else
      args << "--without-mysql"
    end
    args << "--with-psql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
