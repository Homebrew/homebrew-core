class SatelliteTracker < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "f09223c10ae65d8b6e92a6ce2fac6489c6f0f110fb014514988160ef47f2cd1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "449f90c16cf63783f9a5cc7c8267c89b9ee374fb138878a98c1f4aa217b42d22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dcc00926d667b08827468779c5bd6f21a654e200bc1861d8bf176d99be751ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "891082793dede1336b80e8ea07abac8db7053d2296768027b3b7530c59b5692f"
    sha256 cellar: :any,                 arm64_linux:       "047292109959d07d3867c8b95d60933945af2fa6c5716208f5c8b61a14d5f947"
    sha256 cellar: :any,                 x86_64_linux:      "8093bf71f10c6dd322873c93cd1bdffe979b2b8af01e58ec2ce69a24df2820e8"
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
