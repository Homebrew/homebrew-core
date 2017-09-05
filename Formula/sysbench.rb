class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.9.tar.gz"
  sha256 "3e472d5b175dcc5a8b0ebdf102dbe64bdcc712f6c41812849490e739bf8ce483"

  bottle do
    sha256 "9c5faeb3dd75b8a37cfc16982648075f0e77733d79959286b6a9443ba33ac12e" => :sierra
    sha256 "66c2f958b10e0617fc762ef9c5c8d548deeb2d5d5cd7c216c92baa52582740fd" => :el_capitan
    sha256 "ccd5f98284f2831c1a3e335cd7098691d71002d1c7790615ea0ba460ccc65d47" => :yosemite
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
