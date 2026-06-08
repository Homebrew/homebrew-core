class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/refs/tags/2.1.0.tar.gz"
  sha256 "8a9ec9752fc64e589f6d48a0bcbdc91d0edf5e90663d9077daceb4eefa31447f"
  license "GPL-3.0-or-later"
  head "https://github.com/radare/valabind.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96644c5f33f86c6ede04624797bab4dc30b9c3b13437307749cd7c995023dd7a"
    sha256 cellar: :any,                 arm64_sequoia: "a0ab6a915e8f5d8f4335c97b059775eb6dbe465f5d9cb856383a82adef6a8182"
    sha256 cellar: :any,                 arm64_sonoma:  "87f6095868b5e55bca86b0da90c6d2a752e39d3cbb25f9821288c61036e9d764"
    sha256 cellar: :any,                 sonoma:        "0d56e665c0b9323dab09738d8ace9494c8b390ff5456e058bc65ef7a1f05009b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14ea38be553a7a0bc77d84575a0cf94a30b0ecfdad6a8597f7739ffbdf81a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed2b873a26f57eb8ed395e320866f917f7b7d0ac7d666695dd80cf4930769a6"
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
