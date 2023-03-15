class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.23.tar.gz"
  sha256 "b8839a6f9552952887565106332da9e9d1b4852e49e5ad4821d263102a63a721"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd98e3abe31ff37f19c1ea9b4571926cb63b61aee26bb4369d67689e2bd088bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f224950d92ed04e7dad1a5100c7fce3a54dcab1ea874d4edb7d07cb4c123e19c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff2249a3522477780b7413b5f20b84e581212bfcefa28fa1ac5e5c5028327d16"
    sha256 cellar: :any_skip_relocation, ventura:        "a79162869aab78336b39c0f544d3168d4d12654b05280227f2fc1e9bc0aaade5"
    sha256 cellar: :any_skip_relocation, monterey:       "646a688e182b24d37cffdcabbad1072adb55e22d371d856297446b77ff0162ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc8741459d89e7ea98d12b73e3b998b0086a8c63c317c3b83a84dea50e3c6901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d794d53d918c0b857811e2e6db8f27fe8f21d18619037e131d43b1ba08f6fd9b"
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
