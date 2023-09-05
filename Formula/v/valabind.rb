class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.8.0.tar.gz"
  sha256 "3eba8c36c923eda932a95b8d0c16b7b30e8cdda442252431990436519cf87cdd"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/radare/valabind.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e28af78b2d274aed69831674e266fca2dd7d5d372c6fad894b781e2f7921441e"
    sha256 cellar: :any,                 arm64_monterey: "f97a49df3bd721459f95344eb6797f64dfc3179e3472c9fb559dd1e9a6f5407f"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3b71cafaf1ca949145a4e2045228091c58ced1adf4ac750b380e4f0e3d22e9"
    sha256 cellar: :any,                 ventura:        "33cf37fa5a4819b5f8c79adbf0ed5808873779541ae90eca8abccd2f020f5451"
    sha256 cellar: :any,                 monterey:       "564959ce8e6bec75bb130cb85bc352a33d31fdd97f8252dc8bc6ebce79bc4f5f"
    sha256 cellar: :any,                 big_sur:        "0d194995ef330fa38ccb9ed89038f8309c7c9fb84592301f73a3ae07e83504f7"
    sha256 cellar: :any,                 catalina:       "4bd9b0d76eea42421f543452ac64b28a3ae852556c6a82fd32fe09538c78809b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a026ff063223ac9af89b8fd78aa1d610cc20771b3995dd9b39bc2f2e6ac04c19"
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
