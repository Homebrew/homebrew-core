class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 4
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "c5ad6fe97fa944521c3848f282a940aa3f37d22bc96a472d6f320715f679b38b" => :catalina
    sha256 "e120768e4de31c6d5efcfd3e09eacf59c9b8d2388f3a402a296fc13a50c35263" => :mojave
    sha256 "90ee3663f74b52b5efb182792bbb4bd76780929bc7444dd319dcf51d27888390" => :high_sierra
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
