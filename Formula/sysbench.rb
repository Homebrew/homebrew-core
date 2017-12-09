class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.11.tar.gz"
  sha256 "2621d274d9103496e22c57863faec11f855f25db838fae0248be6e825a426dbe"

  bottle do
    sha256 "71501daf2051bcdc9bc34047e11e532128f7a7998559bf46e7478c54d92d6292" => :high_sierra
    sha256 "b0ca4c4ba1b18d15810ebe62bf751df313870d29b6488b5cf584b62cd518cb47" => :sierra
    sha256 "aa258212e72d3c3460a3ad741fd27e166d2d0c532d3a772a706a459b76b467a9" => :el_capitan
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
