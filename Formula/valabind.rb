class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 1
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "a1d10cd047c3138073ca801e9b329099b54699934c10c5b0d19f0715700427ae" => :mojave
    sha256 "1ea10f1718863eab9d776ffa851ed373a9e2acb36ade53facd63f9b0cfd045e9" => :high_sierra
    sha256 "d034e9ab2b3f8ac4fcd9396813cbb39d048006a8889cb4162c26b7b78787a296" => :sierra
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
