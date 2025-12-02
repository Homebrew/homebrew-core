class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "f8317b77e124f0201a47289a1d3e7a196e93cdbec3df9a0fc82d10c934c0ca85"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbadc34bc9fd0c2781278f321b5f6eac57337bf760cc78b507765c15144d3e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4587ac29c0d6e6e476db8d7cff71ddb631444952810d4e05607f426f261e15ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc750cd57cd4d351aee8bfdd772863f147636503025ac644170c5611c79ae2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b429ba673ad3941c2f81ff0f8ae51c5a2bb8f090478d56428b2c2d1729d202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0188852674e18cd97cffb37ff745e71c756cff64ac3b92f3bc2b8efaca339b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475dfa816694ecb56c49245b4970df639aaf78af02cdc5b846532acf9226b490"
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
