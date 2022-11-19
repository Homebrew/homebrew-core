class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/sshfs-3.7.3.tar.gz"
  sha256 "52a1a1e017859dfe72a550e6fef8ad4f8703ce312ae165f74b579fd7344e3a26"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 x86_64_linux: "a98d273e64706971684935a3ae87da16b1dda98f7289eb79e82f4cdfb7f12bb8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    mkdir "build" do
      system "meson", ".."
      system "meson", "configure", "--prefix", prefix
      system "ninja", "--verbose"
      system "ninja", "install", "--verbose"
    end
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
