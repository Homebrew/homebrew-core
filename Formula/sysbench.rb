class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.16.tar.gz"
  sha256 "c537d0129151584b361efbd4ce9ed0b2195a69b72ce65912e2efa3a68f28b609"

  bottle do
    rebuild 1
    sha256 "88e3ab23abe4cefc6c3aa3971a1572c122dc6da07d16be8a7a507bcfe65e7440" => :mojave
    sha256 "c0cac7822ea2b4e68b29373f924a8d367f77e42635a9cf28392b41e2f45d3ebf" => :high_sierra
    sha256 "8aae1f5f0966a4ad0915d1443cbc2dd0aeac5e919fbc094af545ad78c2686c5b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "mysql-client"
  depends_on "openssl"

  def install
    system "./autogen.sh"

    # Fix for luajit build breakage.
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "./configure", "--prefix=#{prefix}", "--with-mysql"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
