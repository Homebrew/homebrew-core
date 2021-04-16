class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.8.0.tar.gz"
  sha256 "3eba8c36c923eda932a95b8d0c16b7b30e8cdda442252431990436519cf87cdd"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/radare/valabind.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e1304ff87e55fd7d61e3ee82a1f2d4faad720b4817adfa6f5c6398a2a4c90e3"
    sha256 cellar: :any, big_sur:       "e6a255cbcfa3065cb00ebdb5b5a72e08d96f1152b749313441a9ab0b824629fd"
    sha256 cellar: :any, catalina:      "59ac7361a4a4bb36beb102f172ac1a4cfe3ca1e611498fc574f0fc5a2b2f4b2b"
    sha256 cellar: :any, mojave:        "18b32d4e6409d4a73d23f226f475fc1c41680d4f7f5da31e1e73cd70f4958816"
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
