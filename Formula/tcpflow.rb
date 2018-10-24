class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "https://digitalcorpora.org/downloads/tcpflow/tcpflow-1.5.0.tar.gz"
  sha256 "20abe3353a49a13dcde17ad318d839df6312aa6e958203ea710b37bede33d988"

  bottle do
    cellar :any
    sha256 "8929b11e0613406e66dae23cb27d38c0dbaf7606fb95cf404e18090a998cac95" => :mojave
    sha256 "0aadaae80b60771c86b712aee5cc13b0bcca0757698fce835384d992dc3a6a41" => :high_sierra
    sha256 "25254b1669a0e7d3ad0507c2ab233b5024203eaaad968c7c09aa4b91a6403f0a" => :sierra
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
