class Rmw < Formula
  desc "Trashcan/recycle bin utility for the command-line"
  homepage "https://theimpossibleastronaut.github.io/rmw-website/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.9.3/rmw-0.9.3.tar.xz"
  sha256 "a7215af12694d50282e4cfb9b9062fb7806bde8770d61a2a0cd8260e28db2749"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "8d58a58079f53b8aaff4b93444acdf5b3d2684544797cc752c96b83da178c4d9"
    sha256 arm64_sonoma:  "8239ccf6bb375fb50584507ab082b82ae08886dba6844ef1e62d3c559145a279"
    sha256 arm64_ventura: "fb4a64fbe3d059aa12d2e70613c6425c31defa93b84cfa03234ac9216c091e3f"
    sha256 sonoma:        "f039fa85ec2de59391e8ba0b15a161f8dbb3ce4bd1c320b481c467917ff754b7"
    sha256 ventura:       "0b8bf09348b50d5781c5fdd00ad6a1aaa764d2a42e3a75899948244489a55f57"
    sha256 arm64_linux:   "3a3d183199b379a095cf196becd893c7c9e701172bc7964d3a525238f40c015a"
    sha256 x86_64_linux:  "90583fca0c8ce43359664635076f3251a3ceaac0d382c9c1879a74156c8f97c0"
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
