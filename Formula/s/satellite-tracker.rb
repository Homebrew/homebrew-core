class SatelliteTracker < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "2cfb81377db86b39faba1159fbbc81481eeb9418ae8c943a49d1aba5bc2b1473"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f753da683186bd736eebcf83f81e3ac239128f37852bd7df3a10dee5368b4c0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ee4fb14612d4c0b911a2ad9e5eacfb1fbcceb3225dcdc34936491867aa4c7b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f6785f9cff682c2469e2a97dc5f3a62358f8dd4cffea8f5fbf3f4d7c5aad19f"
    sha256 cellar: :any,                 arm64_linux:       "ca2215c26fe977991b2d25c70d9dc8cc6ba771438ec9a3d407511ad0de60cbf8"
    sha256 cellar: :any,                 x86_64_linux:      "b7cbac7f6e4dbe3bcc1b1ffce3693ec9e807038a88bac2e1315c6a5c96c38865"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "expect"
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    (testpath/".config/tracker/config.toml").write <<~TOML
      [world_map]
      lon_delta_deg = 0
    TOML

    PTY.spawn(bin/"tracker") do |r, w, pid|
      r.winsize = [43, 120]
      r.set_encoding("UTF-8")
      refute_nil r.expect("lon_delta_deg must be a finite number greater than 0, got 0", 10),
        "expected invalid configuration to be rejected"
      refute_nil r.expect("Using default configuration.", 10), "expected fallback to default configuration"
      refute_nil r.expect(/\e\[6n/, 10), "expected cursor position query"
    ensure
      r.close
      w.close
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
