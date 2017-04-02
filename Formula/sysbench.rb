class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.5.tar.gz"
  sha256 "6a97fa0008c3021ec3ddbe5d2dd5b69e2d1070c872eb914d3ac5134f163954a3"

  bottle do
    sha256 "404b5a31bff80d60da02b8c3aee5a08f2968c553f72342095d64e1632c993174" => :sierra
    sha256 "fcd4b5ac02067a797613119e19eb1d50f5295d3597607169caa6a6f142c417bd" => :el_capitan
    sha256 "a253720912f37bb8354f4202f1d8a2979dedb43d70adf377d1f270d31dd05ad9" => :yosemite
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
