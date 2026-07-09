class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.6.tar.gz"
  sha256 "67a3e166a39b07708497ee0aee308547dba386053cf8d816b4ce8a9b3066a6ce"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_linux:  "7cd31765aaf53ab1f36203742ab247b2e22d1831a6deba03867e966b4a755574"
    sha256 x86_64_linux: "aa642c08df37aead0f8f4ebdb02806f77b2be6086b2efb6f0703751367b5ab3c"
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
