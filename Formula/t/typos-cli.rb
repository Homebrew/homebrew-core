class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "566d72336c40934865e0f520c7983d6d84cb23ed7660fae48ebdb1a8c12d076d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1e4bd24d51c015f1b28d7d72486904e3e280693d04a0edc5eddbca9431ab6fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbd353f776201f04360f1a838eeb8cd2ead378e4324258da299b5aac84c53671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a5689253c90a22353f29402b97e9a22a2c44d09ec04728f42487e594e1c630d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a01ecd099aa487435221da1abdfc59f00d0a33435325f772296623ab54422ad"
    sha256 cellar: :any_skip_relocation, ventura:        "d829f091610e6ee254658993897c7b031be77f8ad0fbeb0ee707b37f1ecb04dd"
    sha256 cellar: :any_skip_relocation, monterey:       "fbe54af469fc187e0ed63c153cceb747454abe0ab77cbda541fa04c7f97c7494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0494ae8149da9b9b681df4efe57a65065d2fc67fa4c0706b36933dd8a0ed3703"
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
