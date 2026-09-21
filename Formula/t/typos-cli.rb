class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.50.2.tar.gz"
  sha256 "412b161d33996e2c3c4a8b076e22183527f3420242975e868ba9968a3ce1727e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9aa37a6da3929cff2d4c61e778ed9a1bf1d0016fe897c52bf387a2639552eed5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c8e8196b244bfbb2ab48db84757a3e38de179a38d0bd095dea3a24a4ae49814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe5344eeb1b3787092e874dbb98e73e4a5bb033d3e0d133f736f4e51bf637ea7"
    sha256 cellar: :any,                 arm64_linux:       "ffedde767da4c34b432d1995a1b5d33dbf1ee266880bfb47284a4b15de7d2ab6"
    sha256 cellar: :any,                 x86_64_linux:      "9b52cd497978f0f9bede5cf29d841ae6ca35ede1d00a28c1ffb8b545bcc77ead"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
