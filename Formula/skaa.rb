class Skaa < Formula
  desc "Seven Kingdoms: Ancient Adversaries"
  homepage "https://7kfans.com"
  url "https://github.com/the3dfxdude/7kaa/releases/download/v2.15.5/7kaa-2.15.5.tar.xz"
  sha256 "350a2681985feb4b71d20677d1a6d11921b9e3d97facbc94e4f020e848d8ab2b"
  license "GPL-2.0-only"

  depends_on "pkg-config" => :build
  depends_on "enet"
  depends_on "gettext"
  depends_on "sdl2"
  uses_from_macos "curl"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    executable_path = "#{bin}/7kaa"

    return false unless File.file?(executable_path)

    pid = fork { exec executable_path, "-win", "-demo" }
    sleep 5
    system "kill", "-9", pid
  end
end
