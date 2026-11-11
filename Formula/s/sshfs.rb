class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.7.tar.gz"
  sha256 "3f2873a2b7e7bdd3179ce2a5ee00d219a043cbd75d5be42ccb9707123a90418f"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any, arm64_linux:  "66f3b0019089bb79136502cc506345337218e47c3ccc9c172a3629bf02c20fcb"
    sha256 cellar: :any, x86_64_linux: "98dc4a697717c8ff30e89775dd14345531123372d1fcfb6925f3fa01274fd9e7"
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
