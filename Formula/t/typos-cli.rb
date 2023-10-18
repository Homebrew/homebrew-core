class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.20.tar.gz"
  sha256 "41ac21863c2036a29f0e17e9146c29831d5764513c321d55274bdb2b3cd63290"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "909f37e7fe128ecfb454f8f7b5a69ab32ab1eaa93047a2b929c011fc1212448d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71aa81b6fab36e4d33cb11c1d6cdd2f439edaa5810a0dbc1ef23d32a3dd24a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef78557e99fa74686f81446625ea3de34027eb6c8642962d8edd28e72755f87"
    sha256 cellar: :any_skip_relocation, sonoma:         "30df8baa8156dc80a4842b4ad95233366a8bb051c09e0f723483ace53aea5144"
    sha256 cellar: :any_skip_relocation, ventura:        "b256ee316849870bde326be7861007271cab7365bc9b4f274c9ffe01846073d8"
    sha256 cellar: :any_skip_relocation, monterey:       "5259fceb79e01b269936220587b48c058ab57834f80d83c952bcd27e393e2a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716aa25f9d8b17c5c43fe6b6eee321b87963c364473bad6a2e7ae7c9b0e692da"
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
