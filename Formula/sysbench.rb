class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.14.tar.gz"
  sha256 "81669cee6e0d5fccd5543dbcefec18826db43abba580de06cecf5b54483f6079"
  revision 1

  bottle do
    sha256 "fcb780c85ec232d60edbbb9fbdb384c3f8e3a26314e625a5bf60461905b636a0" => :high_sierra
    sha256 "56eda0a58313a0ac098b2cbbd1ac6c68b8c487c0dbdcc996b486ddcb2f1fabc0" => :sierra
    sha256 "d00d69c96c281d3185ffe1db96e625a3baf8b392098c681f560d7b72e605ff09" => :el_capitan
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
