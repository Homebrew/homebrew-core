class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "268459bd3b03d4e6c398280ade11d5280850fdb392ed50d3c67e41ddfa083dbc"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94fa18ff2ca39285f0194e5f570e8966b7cc9f55d0e2e34de552962dcc6cbfb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32eae6cff9d093e33f8ad4702e1b5542ef02fb4a04e31a6cab32fbd50a56610b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01bd99ea999aa8c2ea18f38b0a923e0bb855599beaf367a3e280ab0cab4cf0cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1834a26ece876c662780952b63eb6f0fd59759166c7a8b89842cabd29598923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64bde66cd84b962e01fa9908a225e55c179f2b358ad7aa2c5e7e9af414b321f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a6defc5b7c3dfb47a6424ff03593458251f73609360987167a1a2dcaeeb12b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
