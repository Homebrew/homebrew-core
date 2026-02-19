class Rofi < Formula
  desc "Window switcher, application launcher and dmenu replacement"
  homepage "https://davatorium.github.io/rofi/"
  url "https://github.com/davatorium/rofi/releases/download/2.0.0/rofi-2.0.0.tar.gz"
  sha256 "f81659b175306ff487e35d88d6b36128e85a793bfb56b64fa22c62eb54c4abd0"
  license "MIT"
  head "https://github.com/davatorium/rofi.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "56cf0ce09c7e1c24b44a42074ce27963461dc6f1494a231d67878607cc4445da"
    sha256 arm64_sequoia: "d0b9f23ea3e63509aaa2dd9bf00c033973ead42dc9e3a4f25c3d62726195ec66"
    sha256 arm64_sonoma:  "0fd77e4788c2add3bc3b4b9ff0ccd525c18ee084da1aa236ed788e0ba4c89e33"
    sha256 arm64_ventura: "d428713688ec3c0966f0ad16c465bb683db9fa66690ff1b906694b63963d5fbd"
    sha256 sonoma:        "9b93ea8da34ccd6ba683b62e20d354377704b272e5f288fc09e786d549a027f2"
    sha256 ventura:       "4fece57aedd09cdb2b7c65ddcd55f42eecb446570ba26d58d46416ed39b99c05"
    sha256 arm64_linux:   "481b5771288fe8bdda79947b5662d8660b3db1d497259bcf251954d3a9ec000d"
    sha256 x86_64_linux:  "fcfbd2f40d45b02ada2b790949354a4b17382edd6fb84a16815f57045e1e6793"
  end

  depends_on "bison" => :build
  depends_on "check" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "libxcb"
  depends_on "libxkbcommon"
  depends_on "pango"
  depends_on "startup-notification"
  depends_on "xcb-util"
  depends_on "xcb-util-cursor"
  depends_on "xcb-util-wm"
  depends_on "xorg-server"

  uses_from_macos "flex" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # rofi is a GUI application
    assert_match "Version: #{version}", shell_output("#{bin}/rofi -v")
  end
end
