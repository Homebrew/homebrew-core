class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.15.tar.gz"
  sha256 "7f004534ae58311a010480af8852b3ab4fdacd2292688e678bed9cbfe68c3c06"

  bottle do
    rebuild 1
    sha256 "88e3ab23abe4cefc6c3aa3971a1572c122dc6da07d16be8a7a507bcfe65e7440" => :mojave
    sha256 "c0cac7822ea2b4e68b29373f924a8d367f77e42635a9cf28392b41e2f45d3ebf" => :high_sierra
    sha256 "8aae1f5f0966a4ad0915d1443cbc2dd0aeac5e919fbc094af545ad78c2686c5b" => :sierra
  end

  deprecated_option "without-mysql" => "without-mysql-client"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "mysql-client" => :recommended
  depends_on "postgresql" => :optional

  def install
    system "./autogen.sh"

    # Fix for luajit build breakage.
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
