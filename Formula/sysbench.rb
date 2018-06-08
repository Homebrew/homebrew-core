class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.14.tar.gz"
  sha256 "81669cee6e0d5fccd5543dbcefec18826db43abba580de06cecf5b54483f6079"
  revision 1

  bottle do
    sha256 "f7fb7d35da8ccc78ec00ba594dc62e1edaea6d4e7578b7fdc8c3868ce6213489" => :high_sierra
    sha256 "c219107c3118144380458fd32205906edfe7b835b927417065ef5b89f48e56fa" => :sierra
    sha256 "b26c1f7a5f77bdd4b5a3261aafcde1e908527bd4ca8cb5e93dde2811f71570c5" => :el_capitan
  end

  deprecated_option "without-mysql" => "without-mysql-client"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on "mysql-client" => :recommended

  def install
    system "./autogen.sh"

    args = ["--prefix=#{prefix}"]
    if build.with? "mysql-client"
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
