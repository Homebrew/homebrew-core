class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.3.tar.gz"
  sha256 "37e3d1ecd3e3917695bdfa314ebf09201433d3b4c1c7c0bd4a903bde4e69472e"

  bottle do
    sha256 "c208fd0036f263be4d8370e2c1a4719b87ce839128ebfe3f5ec3942c53032446" => :sierra
    sha256 "ab48701d9ff54863bae71e6467d5b4ddc4875ed3ad0451cd2620177aaee2d322" => :el_capitan
    sha256 "4661e6f0f5c7b375dd5cd1f98d94b8251a9adc365b39e92f9049412724d07da8" => :yosemite
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
