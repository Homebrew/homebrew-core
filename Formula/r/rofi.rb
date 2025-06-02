class Rofi < Formula
  desc "Window switcher, application launcher and dmenu replacement"
  homepage "https://davatorium.github.io/rofi/"
  url "https://github.com/davatorium/rofi/releases/download/1.7.9/rofi-1.7.9.tar.gz"
  sha256 "6a2861ab8a2332fdf99bfcb8bfe0ffc85f42ea20900f7b0c30f4575ca5699e5b"
  license "MIT"
  head "https://github.com/davatorium/rofi.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "12f2adcbff734077b295a28576edb770f00778986de09c6ca1036393270f2dcf"
    sha256 arm64_sonoma:  "31b072b30a9a55cc505de3cbd7323dd21b826b061516685b473e51986cab3d57"
    sha256 arm64_ventura: "ea99ce4ca56b71bf7d71a0a197395b36356664c60b48665780d72ae794672c46"
    sha256 sonoma:        "d2454914ee0ac50fee8f4b32c1fce3ae4938545f030717bc6daa5cc6bdc2388e"
    sha256 ventura:       "e9a72418949e0a14e93cd99e1e8bdcde1854ff02785a8bf84f36bf3d11b2cc1a"
    sha256 arm64_linux:   "d52a687e7f1620bf65e7e6f0237afb757ca7bd82fdf62a3e26f3c4e08da8a71c"
    sha256 x86_64_linux:  "a950e63b3d4a61933e919da55be04620770209eadc73e815ed6d6a8d8b41cf65"
  end

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
  depends_on "xcb-util-wm"
  depends_on "xorg-server"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "xcb-util-keysyms"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    # rofi is a GUI application
    assert_match "Version: #{version}", shell_output("#{bin}/rofi -v")
  end
end
