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
    sha256 arm64_golden_gate: "e805d21f6c7e84f04666d70ad1f024c52782717771e38c24a58a1fc36a81c52c"
    sha256 arm64_tahoe:       "c40c67a1afdd8c62c0fbcc51ff980a68dd353e236154894484e4bb8e1e9c12a1"
    sha256 arm64_sequoia:     "c9e40bf4c510310374b7b875b771c73d3937ccd1c775acd7c6c39dd4e2439c7e"
    sha256 arm64_linux:       "c567c739ed8186bd3decb07020ae55222a5bef553900690b9b0262b2d1840761"
    sha256 x86_64_linux:      "f707ed49ecc6c3bcba1c5d347860e019af27ccff21cdec99d4f91271fc773e03"
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
