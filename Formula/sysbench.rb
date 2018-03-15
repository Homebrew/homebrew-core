class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.13.tar.gz"
  sha256 "32082772dbb1a3c0ab7899b6678817f1386f2e9ffdd0da005ca59f904dafc12c"

  bottle do
    sha256 "101c6991e10c7cc71e4c897091de5c749e7b99e4fb7770d8409f7cdbe8c67b56" => :high_sierra
    sha256 "e07e64a74d5a498f0c771758af84a97e94bc4647460c49f69ffc28ac4e56c166" => :sierra
    sha256 "8d5bca3db857d2be65ad1a764c4a3a1e152bb38a1d4c7d07bb8e6d02642030ad" => :el_capitan
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
