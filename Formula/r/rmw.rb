class Rmw < Formula
  desc "Trashcan/recycle bin utility for the command-line"
  homepage "https://theimpossibleastronaut.github.io/rmw-website/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.10.0/rmw-0.10.0.tar.xz"
  sha256 "8f96fd96831b69bffc8019cb000483ffe92a7764765484df57f63a6515d26fd9"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "582a1e00f4cfa06abc1d1c928db5e6e9ddf37e6b510b6be414991ee75b9b6b0b"
    sha256 arm64_sequoia: "6ac0b6ae8b0fdb7c34048cbe2b65a32e8e1c18a75b25cc6ec5486cf487e05882"
    sha256 arm64_sonoma:  "c3149b07cca673b4ed9e4c880cd72e9bc72123fc17e922482f43355907fd5e05"
    sha256 sonoma:        "139d63a0fb57843bd1ebaea407547b0f94cae4e107def758f12f1fef5115bb29"
    sha256 arm64_linux:   "628897b6cd4cad5395e8590af75f9e19dab5211eb19bdf19a25a637ffdd2496c"
    sha256 x86_64_linux:  "39fc9e9f2eee1cb58a285d47708967c49ede620db7f40cafc62c9612a585f3e3"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "canfigger"
  depends_on "glib"
  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
  depends_on "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Db_sanitize=none", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    file = testpath/"foo"
    touch file
    assert_match "removed", shell_output("#{bin}/rmw #{file}")
    refute_path_exists file
    system bin/"rmw", "-u"
    assert_path_exists file
    assert_match "/.local/share/Trash", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
