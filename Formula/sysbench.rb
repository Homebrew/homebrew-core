class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.7.tar.gz"
  sha256 "db91521e70b0d1a6fccc60a8d4acadacb3f9328e8ab6802ae82f93393a688d43"

  bottle do
    sha256 "97a8a6623055c8c4d04a4fa7d3e841b9a4d87b87e00e647ddd3d6e5a1694bb8a" => :sierra
    sha256 "f5eb0e912dbe3425a3d6345bd01610d48e88210a8662da10fdc4bb25c71be0d4" => :el_capitan
    sha256 "ff16e2ddfded71eaa0f683353b01cd7fe6c2850fae15d15686b95540a55be5ce" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on :mysql => :recommended

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
