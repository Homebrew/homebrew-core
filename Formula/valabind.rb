class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
  revision 3

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "c0e12dc929404794cc14061bb410ed8f156607ec72722d0d1dc564b48d6e49db" => :sierra
    sha256 "76dd86a5634171b12cb63802cc7d6d944cd5307982975744dfa96d7babe0fc32" => :el_capitan
    sha256 "57c5f65f392082c54cfa7f3fee715a4bf767892d102ea2bf931d14eb11dc1dcf" => :yosemite
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
