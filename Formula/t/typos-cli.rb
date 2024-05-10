class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "64de2b4dcf92b96760e8b7861eb24475b3161fb1a500a9006b414ef506f5bd3b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f31c53cd756522db4a5d7e19169a7c9fefaee133ff5aea356ad0db6ff1fc890e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a3c390672534c9b102567b5b0565bf3f683ca3a9e5e9dfa77b0a49a0428a7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea123b708fbcf59a73a5b092edae89563abcc1d30d45d1fc2de37f7ffebc5f79"
    sha256 cellar: :any_skip_relocation, sonoma:         "b149746689e00305b28aaab4c38027ee688043cfef0d553afb5eac46fdd7f052"
    sha256 cellar: :any_skip_relocation, ventura:        "d002d66e86d30da50a752c578e64b97f42c1ddd9bd8ced77902bc425817935ac"
    sha256 cellar: :any_skip_relocation, monterey:       "cec5305f7851ae09fe5969d4669d238d3c2c9534e2e127878d5ccc8fcf5d3f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "754a455671e43141874eabf2e94ad73a1f171a11de522e525aa492b8b6ecfc1a"
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
