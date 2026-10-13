class Thokr < Formula
  desc "Sleek typing TUI with visualized results and historical logging"
  homepage "https://github.com/jrnxf/thokr"
  url "https://github.com/jrnxf/thokr/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "982a5d1860e56ec02abb5560424e4c9668b30264175aff097eaa834f817df75b"
  license "MIT"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/thokr --version")

    require "expect"
    require "io/console"
    require "pty"
    PTY.spawn(bin/"thokr", "--prompt", "hello homebrew") do |r, _w, pid|
      r.winsize = [24, 80]
      refute_nil r.expect("hello homebrew", 10), "the TUI never rendered the prompt"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
