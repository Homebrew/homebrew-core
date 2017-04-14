class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.6.tar.gz"
  sha256 "cd23c622da3d3267885ed126540dc04c578ee16c3d31307e21b5acd8e4036eda"

  bottle do
    sha256 "ed100c17b5394daf7e9c34c1c538ffe43f0a27d943a9b92c0801bfe7270a53c7" => :sierra
    sha256 "6f8cb9c562a73fc5e60b95a661b06f1134076d2d3430cc3f9430969fa738d58d" => :el_capitan
    sha256 "8654c2ef9d593fcb5d7ebb58ac9e8d7c99aa78785d45eaafc8a49b4f86e0f65f" => :yosemite
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
