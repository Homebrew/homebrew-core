class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "c5c1e6bc40aed45c5e96d69fa5089e3f12790456800bd50c05481b08c542ded3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9648ee5d8662cb5aae93107ee3113184857420a7cdd68ceeb9fd9730d3ad3935"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e293a216edf70088bb7fa55056ab58109d750b49af736c00515db4caa1fc939"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b3352899cb47644ccf6c7ce56a0fd54996080e9414147fdb2472dab1508c7b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef418379f06518f67fe6512fcb441e0acf420fe8c0b30c1a156a8b223eb47958"
    sha256 cellar: :any_skip_relocation, ventura:        "ee1c59084edb0083b6ce4bbb2255167770bf586117ef036722f337c2297bc465"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3ad8d836b1e04ec487c92c64f787e1a91405549e4323e30aa578c4e6184b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9f2f2a3250d095c291194088cc688d9928d947edb6df00d4baf0196bf273e5"
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
