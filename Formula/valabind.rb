class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 1
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "97118de180e5871fee96c4a8de602b626ce5240e5e8d4f7e1783f1a09c985da1" => :mojave
    sha256 "84c2f3f9fcb4216e50cf3a2f78733c4219f8e88dd38149f3b8f4c39be897b195" => :high_sierra
    sha256 "8376e0ec22d6700263cea674b53f4fdaf7dca35c04c6656df9566c24fa1121e2" => :sierra
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
