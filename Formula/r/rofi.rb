class Rofi < Formula
  desc "Window switcher, application launcher and dmenu replacement"
  homepage "https://davatorium.github.io/rofi/"
  url "https://github.com/davatorium/rofi/releases/download/2.1.1/rofi-2.1.1.tar.gz"
  sha256 "5fe33afce841994eebfc0302ba869e7b9c035b97c26858fb0142a54a1627d3e4"
  license "MIT"
  head "https://github.com/davatorium/rofi.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "3f7e5d593c586b89cf9040b012e2a06ff867dd250bedd0d7079d5961f99e0c0e"
    sha256 arm64_tahoe:       "5e4370e5629d6e689603fa92f1d638673e6f2da0086b867463e0142682d1fd7a"
    sha256 arm64_sequoia:     "aba0c508a865803a915310f4d26229502b54c404ed323e3bfa76f7dabebcb65d"
    sha256 arm64_linux:       "f8be91ab0d17ecb880ff4fa1a1640577a7897b98b6f8f118f14cb6e4ccfcb587"
    sha256 x86_64_linux:      "ce477a194ed6f2b2014dc6749b41ae705a3f40e068d65178f7c37078fc898819"
  end

  depends_on "bison" => :build
  depends_on "check" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
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
    IO.pipe do |read_io, write_io|
      xvfb_pid = spawn(formula_opt_bin("xorg-server")/"Xvfb",
                       "-displayfd", write_io.fileno.to_s, "-nolisten", "unix", "-listen", "tcp",
                       write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = "127.0.0.1:#{read_io.gets.strip}"

      output = pipe_output("#{bin}/rofi -no-config -dmenu -filter brew -dump", "homebrew\nother\nbrew test\n")
      assert_equal "homebrew\nbrew test\n", output
    ensure
      Process.kill("TERM", xvfb_pid)
      Process.wait(xvfb_pid)
    end
  end
end
