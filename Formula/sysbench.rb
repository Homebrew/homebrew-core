class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.4.tar.gz"
  sha256 "fa8dbc56ddfd095b09b977c321f7ebbb12818cfc872542a0bffa195cab0716a1"

  bottle do
    sha256 "984c166d3089dcd46fde18a2d0058d157619cae4de20bfcd1ae9645e675f441a" => :sierra
    sha256 "01e4a62c33dd7fa015dbe825c8416eb24c6aae988eb5459a68fc3675a9b52be1" => :el_capitan
    sha256 "ce857222f35a6f76b34ea5db987816ae68b317daa112d9bb2fd958ac44b9304d" => :yosemite
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
