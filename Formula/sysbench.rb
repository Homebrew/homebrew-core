class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.15.tar.gz"
  sha256 "7f004534ae58311a010480af8852b3ab4fdacd2292688e678bed9cbfe68c3c06"

  bottle do
    sha256 "740f0373ea12e4812cc08784afb66b882824a872fb039709fe300e4e9d4722a5" => :high_sierra
    sha256 "3ca9a7a5916b4b2c03006ef9631a1407e91839ae71a6bcd331bfadc7b43a0b40" => :sierra
    sha256 "e23ddd915baca556a39c4bbf7bbf92dd13e306c6a98028b9bc0af2246bdd7a23" => :el_capitan
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
