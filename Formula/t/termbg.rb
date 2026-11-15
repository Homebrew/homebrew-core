class Termbg < Formula
  desc "Rust library for terminal background color detection"
  homepage "https://github.com/dalance/termbg"
  url "https://static.crates.io/crates/termbg/termbg-0.6.2.crate"
  sha256 "8bf44577a1adf3dfd7fec3b8763074467e27b2ad35ff9157bc3f0a51bb0a3dd4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dalance/termbg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db008794471f7af5971351d24f9c3c3aeeecb19b0cabef3a71ffcd16ac557a54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7a36f434cb220c34b75d51cac6d431e730f17828c2a6135a69e24d10eab4f10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5187b8ae2a4ab84c24ba076b8540a1cec8c515c1c9aed3c4364e102e1dbaba1"
    sha256 cellar: :any,                 arm64_linux:       "446af6827d3b2e4d403805b7474efba03ecb8746105c58c6c5b2ced34084c8ec"
    sha256 cellar: :any,                 x86_64_linux:      "9dacf8f520abef0f9e1985911c52f06d0563bd476252da7efad177b3c9d480a3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termbg --version")
  end
end
