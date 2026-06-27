class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "f5f7ec34b29ba62bde898ce7a5674cfc96abca71c056368e7988f3fab38cd2e7"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04a889999f1f02e0b27ea8fac817fbe04721462ae186d95e4fdaa1285224f573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4565541262cac2ce55736f761a169a56c069407078f4abb73db5b4a8171662f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c894cdeeafaf2ebeb422d1a3dbd8bafc5cec54b38d6b55c23f8d6ae0dd903153"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfa0de0fc9bfa045f25ef7cb46a37c520ae54cc0a5f4d74ad1394bf105a11783"
    sha256 cellar: :any,                 arm64_linux:   "ca9cdf4c684167df7343d309f90ab71384c4a5bdd7978f1e5b2b49a8b216eb9d"
    sha256 cellar: :any,                 x86_64_linux:  "dae2980f09405cfdae7d997a416b89f3d3464d6f96c5fde184d4c410957486d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end
