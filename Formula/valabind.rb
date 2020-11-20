class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.2.tar.gz"
  sha256 "643c1ddc85e31de975df361a20e3f39d385f5ced0e50483c6e96b33bb3d32261"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "0094bac8602e80063c793e3630038971c5f074733ce99a8380c8b993c120f401" => :big_sur
    sha256 "3a09089d6ee05b111c373d3a3c407c04f57b64219eedf3262a7fbd6ae83d02e5" => :catalina
    sha256 "1f872f6ddf20d5e101695843bd8feda0d7fc8cea0feb50929b82855481c8da27" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
