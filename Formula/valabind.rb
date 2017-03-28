class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
  revision 3

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "5c45091f83a60a801f1437d4823b9fc3c06b0c76c509298fb894bc9648b7ff92" => :sierra
    sha256 "c3d5d2a3b4a9feaed8ad93bea0a2588d4beffcd21f508ee473af320f3ce75759" => :el_capitan
    sha256 "344ffcc0ca468c9a9590277dbd3a7ce8192f120fb24a696d740da3c5a0216a84" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  # patch necessary to support vala 0.36.0
  # remove upon next release
  patch do
    url "https://github.com/radare/valabind/commit/f23ff9421c1875d18b1e558596557009b45faa19.patch"
    sha256 "9fe8f9485e1a4f52c68831670b880efcbbae33c6bc70e67297a00cc1d2fe0d4f"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
