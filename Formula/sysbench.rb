class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.16.tar.gz"
  sha256 "c537d0129151584b361efbd4ce9ed0b2195a69b72ce65912e2efa3a68f28b609"

  bottle do
    cellar :any
    sha256 "c856c03de69a1d737ef1df2473b94d7ff0e58416f25f590c4a408188e8240b1d" => :mojave
    sha256 "277a98edd7cad5d63b019c44192269d7a70c6684f1f5b0859b608d3c7c85fc7a" => :high_sierra
    sha256 "e89a22e66923d4b1e1c104e9a69b6274265d04e2566e2266805db54d4d92574f" => :sierra
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
