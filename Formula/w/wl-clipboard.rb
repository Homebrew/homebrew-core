class WlClipboard < Formula
  desc "Command-line copy/paste utilities for Wayland"
  homepage "https://github.com/bugaevc/wl-clipboard"
  url "https://github.com/bugaevc/wl-clipboard/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b4dc560973f0cd74e02f817ffa2fd44ba645a4f1ea94b7b9614dacc9f895f402"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_linux:  "2ed9df6478788ec465afc01e214fc62780ff19216a9c5427296d8362a79fa2f6"
    sha256 x86_64_linux: "3c5d5d55a1ccbe9df625a0cd3ca1d64538194afdae28c3d3e36d39a70f3e5cc2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on :linux
  depends_on "wayland"
  depends_on "wayland-protocols"

  def install
    args = %W[
      -Dfishcompletiondir=#{fish_completion}
      -Dzshcompletiondir=#{zsh_completion}
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Failed to connect to a Wayland server",
      shell_output("#{bin}/wl-copy test 2>&1", 1)
    assert_match "Failed to connect to a Wayland server",
      shell_output("#{bin}/wl-paste 2>&1", 1)
  end
end
