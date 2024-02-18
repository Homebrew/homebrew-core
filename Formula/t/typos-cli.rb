class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "0d8b42c9651b2b30a7a7f504f681ef52b61c5d5392f42d131da249ef52c8ccbe"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9827d8e3ab57b0c806a4b2b26291f803d38c2ff49f6aa47c2aa5db49b24920a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33b462c134315405b805f275c3df5d2003a7ed01ab611c4887a3b303346cf899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66cd2fc6c00a8ed2c7bcaf95e8bf3ed22c20360c40b80da1f4c2d3d12a50915"
    sha256 cellar: :any_skip_relocation, sonoma:         "de7225942300afe81479f69087f12f3ba59488bd550e96d99701b1139b77d7f4"
    sha256 cellar: :any_skip_relocation, ventura:        "47c879507d1c78f527d44b1fef2f7908f37b15f675d7651e064797bbc11051f3"
    sha256 cellar: :any_skip_relocation, monterey:       "02e4c296cecf7af15cdb76aab7bab7760eabcdd219abdbb0b7aec2af758b3c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367b3ebf8fc72a2a7b72796efe7dcb0b0a6dcff569ee989734b8ec3b55e91d53"
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
