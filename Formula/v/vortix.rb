class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with live telemetry and leak guarding"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a3efecbbb882ba2f985f9dd7d29accf5e9c521be7cfb1bf8bee18707897ed691"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8746c1c445b6d22d01fce78774d6cfb4de0aa10ed95882a3a52459ce9ec7daa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1e0a77d175b22f861f77a6559c5b858b5d4d95fa8d946693008eb2a0a736509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b28da956f6eae908df95c37d03cab92a938fa5d1fb7dbba691c7134f601ec1e1"
    sha256 cellar: :any,                 arm64_linux:       "f1759ca5780d4ef97fe9e1462bbbfb98606fe1136f8734c9da8e3618aa0a7656"
    sha256 cellar: :any,                 x86_64_linux:      "90c6c97306132d80bedbd3522affa880b29c475214a21e29d175a9d2a4e70f88"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vortix")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")
    # Mode names are checked before the root check, so this runs unprivileged.
    assert_match "off, block-on-drop, vpn-only", shell_output("#{bin}/vortix killswitch auto 2>&1", 1)
  end
end
