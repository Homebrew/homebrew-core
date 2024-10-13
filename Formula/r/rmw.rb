class Rmw < Formula
  desc "Trashcan/recycle bin utility for the command-line"
  homepage "https://theimpossibleastronaut.github.io/rmw-website/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.9.2/rmw-0.9.2.tar.xz"
  sha256 "f1a7003f920297b0d1904c7c79debc06fbb00e1ef62871615a4fe836715a889d"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "9ad3f588bf06a21b78cf3bd4e5a5bf3cae6178b05cb545ec71efadef334ec6dd"
    sha256 arm64_sonoma:   "29b9e30ceb600ae6b8af8f170a72228b6734aee040fd8c48b79d98fed477be32"
    sha256 arm64_ventura:  "9f1dc8c2a1ba4631f3502959d988473e9a55f915a02a0ba8f06f1279846538df"
    sha256 arm64_monterey: "89fda4126f92fe441a6bbd56640aabdcddfc4383aca9214e82914c4f8b79cead"
    sha256 sonoma:         "cdfcd0de3451565df2df12264e14616c144d139508374eec2fea96c0cb4b642d"
    sha256 ventura:        "43ccd75b06bf85779799c91368cb91bdc43ca38449a74b3d7706df10b337afde"
    sha256 monterey:       "4e655492692254ffab63eb9e73193463187f848a0a1583ff4f246a0e1e573fbd"
    sha256 x86_64_linux:   "1b4a5d2dc6c56247cf6abcff5ef01f7262b3d749a559c4f741e99b8483cca099"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "canfigger"
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
  depends_on "ncurses"

  def install
    system "meson", "setup", "build", "-Db_sanitize=none", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    file = testpath/"foo"
    touch file
    assert_match "removed", shell_output("#{bin}/rmw #{file}")
    refute_predicate file, :exist?
    system bin/"rmw", "-u"
    assert_predicate file, :exist?
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
