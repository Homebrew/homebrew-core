class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "ffef623e3b6b83ea1a95fa2ea454e6986ed9f827736e99f114b5b3694fb89008"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf30730b40326b82f4bf37c4c6e425b692c3740e16584ecf8b79b171def15b3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bfdaae70d8c217bb4261493cd891ee6ebb571c02c7bf243fa5505753afcdfe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f348a22bf283fe85c9941a187271a3678f8db816f04a3436345ac3a05b3ad7ec"
    sha256 cellar: :any,                 arm64_linux:       "39c479b2d0e45ddc4cc2a7e9187c991c2cb3a6271c8226f72ada3beb676bbcfe"
    sha256 cellar: :any,                 x86_64_linux:      "f75ab89c03458653b421484e1403b2d30deedb04489449427482b0e2bbd321ab"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "apps/zerocode")
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")
    assert_match version.to_s, shell_output("#{bin}/zerocode --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
