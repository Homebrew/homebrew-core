class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ee75980f3a1b0dde9677af4782decbcd746d7575e7226cca355aad897777c396"
    sha256 cellar: :any,                 arm64_ventura:  "a540153ae627dc66c6849340986d29786b402f23342e690436fd2a66fb140d50"
    sha256 cellar: :any,                 arm64_monterey: "39fb97850d76d1f75eb6563a62f18669d710961f615da885faaeb2e718f86871"
    sha256 cellar: :any,                 arm64_big_sur:  "3911f2d87252dc9664b135dcb0191a76ef65a91af654b4ff6c065ede75b1b4e1"
    sha256 cellar: :any,                 sonoma:         "e05b2b92a9748e310eb2b2f83c77b317acca4c8807cd37e92caf6170e26876dd"
    sha256 cellar: :any,                 ventura:        "6a6c827253ae3de47321f8745f0a092ffe92b6094f600b8ed04e06f0c3f46076"
    sha256 cellar: :any,                 monterey:       "8c40d00afbf4ef01f54f0256112a27e307b91cf9db0e92ba3614ab8c7addcd3b"
    sha256 cellar: :any,                 big_sur:        "da0b71714dcd880e45af93992e7db91119458fa6c8d10ea7c300741fbe7792b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7896bfe211fa38169d1f42294df3aa94ed3d17b87525f5772607862510bcd259"
  end

  head do
    url "https://github.com/libsdl-org/SDL_net.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  disable! date: "2024-02-16", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "sdl12-compat"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
