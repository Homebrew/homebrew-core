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
    sha256 arm64_sonoma:   "c0e89aca645212743b6fd4799b917408a8c30987822e8380a2f2880695648fb8"
    sha256 arm64_ventura:  "8ecc517cbf5ddf44d049bc5630adf389420f90ac59c2cc8a06d6810c3a26d74a"
    sha256 arm64_monterey: "08ce5fa8360cbc3c915094a11ba5ec9cd02204087d18a98014f3ae22c5c91575"
    sha256 sonoma:         "8f8b5b0acdd67752e0a88937cd298cb09dc9a344add9cd20e5ebece1d252f281"
    sha256 ventura:        "637dacc6362f285d7b526762562140c4e1c242c7529e9590430da85602457a61"
    sha256 monterey:       "9e5f6ef50ff462583f2f3e63536ea9a824ce5163b8202d9440a02b7d7b3b9ee1"
    sha256 x86_64_linux:   "e9453c9cef96e81a58479a72c3356642cfde1366cc8e839efdc71b579f10ad7b"
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
    system "#{bin}/rmw", "-u"
    assert_predicate file, :exist?
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
