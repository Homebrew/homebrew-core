class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/refs/tags/1.8.2.tar.gz"
  sha256 "6c0e9f4e83d9735ad71256f6e0586116fca7ecafaba550f3c21d44768c8cbdbd"
  license "GPL-3.0-or-later"
  head "https://github.com/radare/valabind.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9c926bd8926e93770510347c094084d0c7cbeb9f29b9821bd64734a34e66046"
    sha256 cellar: :any,                 arm64_sequoia: "21a0dba49ed0adfee11770b84c9edf52ca7624b0ce0e60e74e1c0c806dcc0ddc"
    sha256 cellar: :any,                 arm64_sonoma:  "521a3a00d54f206857d30c7b1d8b077602e7979292298a1c1148883511effc70"
    sha256 cellar: :any,                 sonoma:        "327c3402dee0879fd0a352cafe5d1c7d5fcccbf2d9996342c7fffd83b7c3a01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52c1abf3408898b2747bd174151256d40eb65cf733a2259fa7959ae12d535fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80daad64f3acc7213a3e2c6eede87599f3ca368569e2e37956ebbe19c6627219"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    # Workaround to build with newer clang
    # Upstream bug report, https://github.com/radare/valabind/issues/61
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "make", "VALA_PKGLIBDIR=#{Formula["vala"].opt_lib}/vala-#{Formula["vala"].version.major_minor}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
