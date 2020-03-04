class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 4
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "533aeb6b5634de0237165620b2650f25f571cce1c43d57a8cfb1af05acb3d475" => :catalina
    sha256 "8d671e3398e213a62ac8a3307cabf87a4f4b0469dccec7d4b6c298173e14f0c8" => :mojave
    sha256 "d181837a5f5795f5d09d0519d0a82bdd8f1c1f5b23a4ef04ff472e31d138f129" => :high_sierra
    sha256 "f3c111ef34b0c9ddd08070bcd23b79ef8df6e11df093d2ad0223c629143d0234" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Vala 0.48 compatibility
  patch do
    url "https://github.com/radare/valabind/commit/9d4fb181e24346a8c5d570290fa9892ce10c8c3b.diff?full_index=1"
    sha256 "db3f6afc2e4ff968d887c1f86ed8a666e2a2f8210e37a18297372265f24cd767"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
