class RipassoCursive < Formula
  desc "Tui password manager compatible with 'pass', written in rust"
  homepage "https://github.com/cortex/ripasso"
  url "https://github.com/cortex/ripasso/archive/refs/tags/release-0.6.4.tar.gz"
  sha256 "c3444fbc30d3536d1f8aa7b6e6cbefff36e8bfaa5e5ff5ef7faf9382a27f142b"
  license "GPL-3.0-only"

  depends_on "libxcb" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "nettle"

  on_linux do
    depends_on "libxcb"
  end

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "ripasso-cursive", *std_cargo_args(path: "cursive")

    man1.install "target/man-page/cursive/ripasso-cursive.1"
  end

  test do
    require "pty"
    require "io/console"

    begin
      r, _w, pid = PTY.spawn "#{bin}/ripasso-cursive"
      r.winsize = [80, 43]
      sleep 1

      out = ""
      iterations = 0
      while (out.exclude? "Ripasso") && (iterations < 1000)
        out += r.sysread(400)
        iterations += 1
      end
      assert iterations < 999
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
