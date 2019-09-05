class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 3
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "80c600b2b30861288dfe1a9738a23194e6ef6248d19c157f99432db87872e50d" => :mojave
    sha256 "113b9207da77e4bd15732cdac43b0ad7ac7aad4a511a4ad9e9ff87fc0922826e" => :high_sierra
    sha256 "f1166c36f5ca7b5bd95b88ddfa95d03e8e7aa049289450d4591778426709221c" => :sierra
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
