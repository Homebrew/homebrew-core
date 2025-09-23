class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/refs/tags/1.8.0.tar.gz"
  sha256 "3eba8c36c923eda932a95b8d0c16b7b30e8cdda442252431990436519cf87cdd"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/radare/valabind.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "745683d881871d85218f78aee42d4631ebc836810ac19aa2b63d6e56fe252b0f"
    sha256 cellar: :any,                 arm64_sequoia:  "ec16d96176ce495628ccf3a5311f73bf79372b0f43916402658f889766a8d671"
    sha256 cellar: :any,                 arm64_sonoma:   "80030cd7d5a34964e901ca0423f7544e4303e8303f3d19f9bed8fe7d05e69944"
    sha256 cellar: :any,                 arm64_ventura:  "e28af78b2d274aed69831674e266fca2dd7d5d372c6fad894b781e2f7921441e"
    sha256 cellar: :any,                 arm64_monterey: "f97a49df3bd721459f95344eb6797f64dfc3179e3472c9fb559dd1e9a6f5407f"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3b71cafaf1ca949145a4e2045228091c58ced1adf4ac750b380e4f0e3d22e9"
    sha256 cellar: :any,                 sonoma:         "f5be1780534f375152b19fde9500b1341a3506c9588adbb0590eaf72dea36dd4"
    sha256 cellar: :any,                 ventura:        "33cf37fa5a4819b5f8c79adbf0ed5808873779541ae90eca8abccd2f020f5451"
    sha256 cellar: :any,                 monterey:       "564959ce8e6bec75bb130cb85bc352a33d31fdd97f8252dc8bc6ebce79bc4f5f"
    sha256 cellar: :any,                 big_sur:        "0d194995ef330fa38ccb9ed89038f8309c7c9fb84592301f73a3ae07e83504f7"
    sha256 cellar: :any,                 catalina:       "4bd9b0d76eea42421f543452ac64b28a3ae852556c6a82fd32fe09538c78809b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2f0a965e11e7dc99c638686a3099d5884b835eca8fdf5424e9062cfca6745a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a026ff063223ac9af89b8fd78aa1d610cc20771b3995dd9b39bc2f2e6ac04c19"
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
