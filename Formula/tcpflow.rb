class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "https://digitalcorpora.org/downloads/tcpflow/tcpflow-1.5.0.tar.gz"
  sha256 "20abe3353a49a13dcde17ad318d839df6312aa6e958203ea710b37bede33d988"

  bottle do
    cellar :any
    sha256 "c971d3d993660862b690239940e4c84d5fd8bffdff776ccba4c038d1eba76169" => :high_sierra
    sha256 "ff6d43a7c67853c6f7a4ffbe9290028a179f0d722e8075395c1f133386778fe7" => :sierra
    sha256 "ea92e38288a2fea16c85b9a937951b8ecc0c5ca619ccff050d36590866543356" => :el_capitan
    sha256 "d5e07b6218d3160b27d12e154910286af4f3edbbbc70fe5879852849a046cfae" => :yosemite
    sha256 "b0e5f0a0e6f6fc81be55627483028a578a679d1c342a7127aa3a983983acef1a" => :mavericks
  end

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "sqlite" if MacOS.version < :lion

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
