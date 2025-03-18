class Rofi < Formula
  desc "Window switcher, application launcher and dmenu replacement"
  homepage "https://davatorium.github.io/rofi/"
  url "https://github.com/davatorium/rofi/releases/download/1.7.8/rofi-1.7.8.tar.gz"
  sha256 "469fba08ad99f286a4a8c65f857c9f66c07e7b9a3496ac1fe3dcd856f3c687d3"
  license "MIT"
  head "https://github.com/davatorium/rofi.git", branch: "next"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "check" => :build
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
  depends_on "xcb-util-keysyms"
  depends_on "xcb-util-wm"
  depends_on "xorg-server"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/rofi -v")
  end
end
