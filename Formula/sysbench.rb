class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.1.tar.gz"
  sha256 "27a1426923d83105448180d7ca9680aad9b00c460a13887bce72f877e13de6a7"

  bottle do
    sha256 "57227064ec68bf24c1c2a7fe0feab46999dfba810f3154a780591b6ece5299cb" => :sierra
    sha256 "a0d5461eeb320af8ff5b2def6db3781170d2d8b985707a7cd96743f5b3353f22" => :el_capitan
    sha256 "4fddb7eb94aae62e59e5fb04ab4962b7f4b2d387a185aaddad2a1ccae8c557d9" => :yosemite
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
