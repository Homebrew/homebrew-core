class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.9.tar.gz"
  sha256 "3e472d5b175dcc5a8b0ebdf102dbe64bdcc712f6c41812849490e739bf8ce483"

  bottle do
    sha256 "77b68c55290a47a5cbbad077737e5e8416e4d3b426abda8bef7fb4a2eb22886f" => :sierra
    sha256 "95dfd521f858f97ae7b24b701bbd790af896a6ef954f8168e0458993f06afcc9" => :el_capitan
    sha256 "3ef822d841520fff15e1b690045b8d168518aca608ee1d74d5d69b2904ce74d3" => :yosemite
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
