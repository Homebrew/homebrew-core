class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.11.tar.gz"
  sha256 "2621d274d9103496e22c57863faec11f855f25db838fae0248be6e825a426dbe"

  bottle do
    sha256 "ea05ab0bb421a4d7c7b4d2192ab0d483764697b83de39c212e17fa6e899fd52f" => :high_sierra
    sha256 "2f97a304fecfbc2428b65f9f760d93177d0a655cf5009b62eebacd4111ad8dcc" => :sierra
    sha256 "deb440f558ad154318daf9587086bf53176807ae8b3a15aff1c3bd2f73d35e18" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "postgresql" => :optional
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
