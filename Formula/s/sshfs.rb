class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.5.tar.gz"
  sha256 "b975121189cb82ed4c675320155a855adf7632abfd7fbdc385ca448d214b581f"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_linux:  "6237fd00c727ad8fe85a3e6c0e6986b07cba640c35cb40db58cc76817313f8a5"
    sha256 x86_64_linux: "1589c3db81b505fb0f853475346572d40bf1d35951578df1da2813dddd84d47b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sshfs", "--version"
  end
end
