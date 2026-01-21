class Rmw < Formula
  desc "Trashcan/recycle bin utility for the command-line"
  homepage "https://theimpossibleastronaut.github.io/rmw-website/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.9.4/rmw-0.9.4.tar.xz"
  sha256 "81c6b7f1868695f4662be45a5e645fd149fda362e8ec1a822d74d735735ba808"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "84a5f3d95667b0b73a17a49d4649fda233e9abb44097225efa537f99399fed86"
    sha256 arm64_sequoia: "1446355fe36c6c169635c74e0a40b478877f690b7f201aa0b23921d2ad225a15"
    sha256 arm64_sonoma:  "7bd3f9d80d766ab2cf306ff6840a99858bc9e93b6a710100f0cca9c2558508b0"
    sha256 sonoma:        "07ecdebd01dfd87db1e36cc87fa5255f70c8d8c7d4fc730b7bb3cffe269a7613"
    sha256 arm64_linux:   "ab15e030b9ed1c6883dcc6c3e574d3d5741dcfdfb6dc3e0e23a0e422f81bd8e5"
    sha256 x86_64_linux:  "3a5eab29ba4ed0ef73d00edf9e33fb2bd424d775973cfaed388360dca1938686"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    refute_path_exists file
    system bin/"rmw", "-u"
    assert_path_exists file
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
