class Rofi < Formula
  desc "Window switcher, application launcher and dmenu replacement"
  homepage "https://davatorium.github.io/rofi/"
  url "https://github.com/davatorium/rofi/releases/download/1.7.8/rofi-1.7.8.tar.gz"
  sha256 "469fba08ad99f286a4a8c65f857c9f66c07e7b9a3496ac1fe3dcd856f3c687d3"
  license "MIT"
  head "https://github.com/davatorium/rofi.git", branch: "next"

  bottle do
    sha256 arm64_sequoia: "9145e5c0e10e0ad16f63c39596fca4cbbc268f2163764242b1983ccc74beb819"
    sha256 arm64_sonoma:  "6fc2c12f38a607c36dcea8cb40e1ad8e6bedebe32f6e027ffc1d7db4128a2590"
    sha256 arm64_ventura: "4521374727e53f0da2f4956fecf809d1f3a3bc6fd7f9bbd8fa731d2c105ffd5b"
    sha256 sonoma:        "d0e422907890194f159c82e5877b4b4a7df6993de3c778fcd2d96cca62e6b7f9"
    sha256 ventura:       "d5825c1f770c36b0de8c90fba3c68eb2ec1fe8b2a62e6d5d1d75f908f5918e36"
    sha256 arm64_linux:   "7fdfa7e381f332b98daf951e158ce891cec5468a158e2388523b8619c0868c99"
    sha256 x86_64_linux:  "132a7447727b17fdc5983bfeaa2317458d65d4146c6c4624588af2724b502f15"
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
