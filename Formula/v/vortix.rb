class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with live telemetry and leak guarding"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a3efecbbb882ba2f985f9dd7d29accf5e9c521be7cfb1bf8bee18707897ed691"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77621d572cc46cfdc2aa431d6a09230c4f48d54f740a58c52485c7600575c8d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de151ab03dcda656b12a0c2fec0a42ebdcbe0ca94a17fbfa38b25092ecb0481e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7526b101c7db1ef2c77bc04d4e259da3a39b8d4bcd51b250fac9d0d7dee5120"
    sha256 cellar: :any,                 arm64_linux:       "a8a7afb6bc7330c1e2d181284229166daf2eaf07981a0a761b7d780ab7d1bc58"
    sha256 cellar: :any,                 x86_64_linux:      "66059903399892b9414c17cfb85f422dccf6087b59e360e477435e6b65fd0f74"
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
