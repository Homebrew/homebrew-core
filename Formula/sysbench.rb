class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.11.tar.gz"
  sha256 "2621d274d9103496e22c57863faec11f855f25db838fae0248be6e825a426dbe"
  revision 1

  bottle do
    sha256 "ac12259c76de51291ae4bb909647fcaf1133c5dfd7f2f0d983f3a1fb0727a909" => :high_sierra
    sha256 "1428b77fd48206693f787cc3028e3ad9e4e3ad8b4159a00a424d567180af388f" => :sierra
    sha256 "91d311d1b5a362777fe8957235d7ece948376a63afcbaf03631fc64822637ee8" => :el_capitan
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
