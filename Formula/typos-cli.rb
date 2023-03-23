class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "1a8b72e3dc6c978543a14d6a38e144afbca06bf0282ddbe0c9a6a856c73f4cdb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65ede858d53f3f2d8c361dc9ed948e41031a4fef50689c34df891bbea88a2897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6dd86879de9becf1277c6c1b3fe7daa77776de2f4b28a43598f23563077b2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8efae86120d9c8786ca4380a7045120a065c11c62d4bcec4f5efef9babe4453"
    sha256 cellar: :any_skip_relocation, ventura:        "8242b3cd35e3bf7c9ee19513c9f9738c7d80b1273564687cbc67427cf7c4a65c"
    sha256 cellar: :any_skip_relocation, monterey:       "54036b64c9d0c05851e67b7ac974fd322e530ba15ec55dad9d48521c87328906"
    sha256 cellar: :any_skip_relocation, big_sur:        "272a2a10e18a9c890fa4a443788f45b2d6c19697d6b183dbade2ea06b9ab39f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8c34829ed56b92f05ccdd89bbe53a09dc72cf5051aff2b6c45e69169d815a5"
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
