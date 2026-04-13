class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/refs/tags/2.0.0.tar.gz"
  sha256 "bb859845b57b1d842c9d2ae0229bc49611be90a9cd3f14927ff96836799c6b59"
  license "GPL-3.0-or-later"
  head "https://github.com/radare/valabind.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "408b48cd4790aa704edcefbe939264dd64fdf41fed8bb1f928315e05a43690d6"
    sha256 cellar: :any,                 arm64_sequoia: "6b516510be85c25b63567eb58abd0dc102864421fb16cbb68c44cbb83507ff13"
    sha256 cellar: :any,                 arm64_sonoma:  "c03c17786b11f5b8c1f347788622662ddb812c9ccb4416ca4b4dc716439ace38"
    sha256 cellar: :any,                 sonoma:        "e329783601f0f9de58ad1bc09f0f853f9bc82c77a158c623621f1fe910a60fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70eeb8a4096d887d7196cb2416323666549c257c9e6a52971a00970afd7a70cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a2ec9556e850ecd2219928a9d5d365871e8b721ae6a1e3930a33032151555ea"
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
