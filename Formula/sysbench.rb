class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.1.tar.gz"
  sha256 "27a1426923d83105448180d7ca9680aad9b00c460a13887bce72f877e13de6a7"

  bottle do
    sha256 "57dccc9defd0420ba3d8d25821c2ce0df26f5d7a0b0123c3f8eebd71e3fd5a5e" => :sierra
    sha256 "58403feaab7db494fb236e41448e21d1b85ac0190206384cdb8bcd81bf4f83bf" => :el_capitan
    sha256 "0ce9b1047f51fde87ece1375ec9d41165a4fbe9b8568cedce8d597148dd265e7" => :yosemite
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
