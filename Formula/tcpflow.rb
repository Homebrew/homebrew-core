class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "https://digitalcorpora.org/downloads/tcpflow/tcpflow-1.5.0.tar.gz"
  sha256 "20abe3353a49a13dcde17ad318d839df6312aa6e958203ea710b37bede33d988"
  revision 1

  bottle do
    cellar :any
    sha256 "ae7eb58e5d805e61b4fc79165574796bf59d2172977579b8716c2ea95631aa42" => :mojave
    sha256 "3b29b20c24395a16a17236a89a5b4ff1121ae2227af79717517b02825a4a7dd7" => :high_sierra
    sha256 "881535a6ab635522f3a64aa9b568ee9fc67476f4636236f17d2828c02518b8bf" => :sierra
  end

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
