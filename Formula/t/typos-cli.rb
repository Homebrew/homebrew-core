class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.17.tar.gz"
  sha256 "7c5987170f02edb1df34a7626855639b8ab2c159b4f6b08b29d8f43727584c70"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39a818352114d62f7b56e5d7ed6117e8ebe842041221e3233b5f9c59856cb345"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8d9395b621a9a6f2a77596a5b08ecc76ebc4ddb76c032ebf18a9b720c7d9a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af52adaf3d18de53a018c62fd915df4b8f7379c154bb66eb508726610efe4b6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d00250b03afd4dfabfee70bd897e0f04f41eaf0535e1909e23982a0d709f9892"
    sha256 cellar: :any_skip_relocation, ventura:        "bc8067a66b5cefb1813221cf3c2415999c556fc18f0612c712f0d71f73b32da4"
    sha256 cellar: :any_skip_relocation, monterey:       "c05f6139a2d15e68a21c5d6d821645cb3cbd8a9a1c9f39e2f914cc8e746b920e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8248f9945d956245e3528c296dfa767cb41fc57ae16d06054d3382189122edf"
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
