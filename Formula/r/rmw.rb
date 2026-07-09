class Rmw < Formula
  desc "Trashcan/recycle bin utility for the command-line"
  homepage "https://theimpossibleastronaut.github.io/rmw-website/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.9.5/rmw-0.9.5.tar.xz"
  sha256 "5fa336da39228d4ef6d1314fd86b5dfb0622e80485ebf7b78152198278090050"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b57378a8a4d9f75baa34ee883b097ff89520a72c080acc369e83aa9158d3e8fa"
    sha256 arm64_sequoia: "55c6ae6efe3afc942a5740fadccaf7eb40826cede8ba926b958d0c401daed786"
    sha256 arm64_sonoma:  "64142a822629df1a6e933259c75f64cde96ad2166366b9bafa34d6f597beba39"
    sha256 sonoma:        "a957b72407bd6253273d0d853903d73db999022ab388e474c6e0eeea460b019e"
    sha256 arm64_linux:   "d1ac5afdcf0c542b5c86959f917303932321aeffa124f92b41b7c9336c026a82"
    sha256 x86_64_linux:  "391320c552df905d3fbd84a4d278b8564beb452e277f01387b89e90eefa31f65"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "canfigger"
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
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
