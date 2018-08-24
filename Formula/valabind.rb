class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.6.0.tar.gz"
  sha256 "0d266486655c257fd993758c3e4cc8e32f0ec6f45d0c0e15bb6e6be986e4b78e"
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "ca08cdefa8d3ca48907a0296a6978cbfd2f53bc39baa96710192cd7d8c3451b4" => :mojave
    sha256 "2a0472b2988962f2f641a262861caabbf092f034e663bcde64f5319c05acb190" => :high_sierra
    sha256 "8d34569ba149d3acbd539dd4fa769b716201053135b17e69f46ecb33a3590d84" => :sierra
    sha256 "eab24bd5e1c87c5ef4a2ac24268d665140e56ba2f574a396bef12fe4c9c8ab53" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
