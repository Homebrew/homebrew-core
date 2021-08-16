class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.8.0.tar.gz"
  sha256 "3eba8c36c923eda932a95b8d0c16b7b30e8cdda442252431990436519cf87cdd"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/radare/valabind.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "57df76865d864be653bc20b5668dd5ce37325d51520178598d3f1fa1c7af43dc"
    sha256 cellar: :any,                 big_sur:       "25cb2f7fc06c507f189f05e95cb24012cc991d9cd2467e0207cf7a98755777f0"
    sha256 cellar: :any,                 catalina:      "d2f11663a729fded04669a0c753eddb459dc6fa29a2ebb504dee18dc8f1185cc"
    sha256 cellar: :any,                 mojave:        "0e4828ea762e635ef5f1fa670afaade9e4106008fe9edcce8346cf233949194f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493239d1c41d39008a87238ce6b69edb0e4b9151a145a2c51dabb3f70a4c844d"
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "make", "VALA_PKGLIBDIR=#{Formula["vala"].opt_lib}/vala-#{Formula["vala"].version.major_minor}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
