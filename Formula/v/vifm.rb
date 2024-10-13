class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.13/vifm-0.13.tar.bz2"
  sha256 "0d9293749a794076ade967ecdc47d141d85e450370594765391bdf1a9bd45075"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "69c488464f2a48acfcae725282e41113e8d69a54a69cf1e1e52443ca20b78c9a"
    sha256 arm64_sonoma:   "f5b9c536515ef59ecb71b659d5d5d65b51d7e785e1694d49d32187fc17d7053c"
    sha256 arm64_ventura:  "da33d548bddd49c65adf0978c4cc494cca83314f63e54138f30cd19ca967ea97"
    sha256 arm64_monterey: "1704a6e7128ab882c015e8b037bbb28cd9d25105eaffaabb07fe633bf8024642"
    sha256 sonoma:         "ba482e8390d4ae4a0eb9b6dbc059a29d9af7cbe802b17d195e6b0c6dd38ca9a7"
    sha256 ventura:        "b01f54c3f7b7b6c2baec3b580e1fd2e7480dd6a4f980e499b5c0f07feabe2573"
    sha256 monterey:       "eaf67e5eded879ea6681f69dc9e76ed9084fef39e23e21f93cf9fa1e588203bd"
    sha256 x86_64_linux:   "2b0fb72b084da7b7d64a0d55ec1b7824f854eb09b23f6a624f806257e19e2cfa"
  end

  depends_on "ncurses"

  uses_from_macos "mandoc" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-curses=#{Formula["ncurses"].opt_prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check"

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
