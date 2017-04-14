class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.6.tar.gz"
  sha256 "cd23c622da3d3267885ed126540dc04c578ee16c3d31307e21b5acd8e4036eda"

  bottle do
    sha256 "1819ecd8b5e33c7d048c9ae8584e0de79e34ba035deb9bba5b7fd5264ceb3037" => :sierra
    sha256 "de484597e7c62b83c1938f4a67bc9b04e7393a6badbf573f0cc5293d253364c6" => :el_capitan
    sha256 "c7aff751bdffdb65b797f54343a71c181181f9781b1cdadf3ba90ee59d5a025a" => :yosemite
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
