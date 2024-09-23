class Wthrr < Formula
  desc "Weather Companion for the Terminal"
  homepage "https://github.com/ttytm/wthrr-the-weathercrab"
  url "https://github.com/ttytm/wthrr-the-weathercrab/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6dbad5cf37fc364ec383f3c04cb4c676b0be8b760c06c0b689d1a04fc082c66c"
  license "MIT"
  head "https://github.com/ttytm/wthrr-the-weathercrab.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wthrr --version")
    system bin/"wthrr", "-h"

    require "pty"
    require "io/console"

    PTY.spawn(bin/"wthrr", "-l", "en_US", "Kyoto") do |r, w, _pid|
      r.winsize = [80, 130]
      sleep 3
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
