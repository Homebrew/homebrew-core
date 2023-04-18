class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.14.6.tar.gz"
  sha256 "3c3336954c926eeb5127c54443c5a53c5a0d5aed3f290b54077f7b72530a4b99"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db7919cf09ad8b8d6b4a01d214bad440bdb0d011d3620248cb304b74b7a96a2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "676c8b0c1f4f7f713db5f0d213b01f32e008563238f743d41f507328852542c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61449e9347f5f48abb8530cbf64f5621c1ff4554083038fcac3be45ba3096c47"
    sha256 cellar: :any_skip_relocation, ventura:        "42ef8258c48c07fb3c825d48a3ce59f7925cd325218e7c2976b08910beb33804"
    sha256 cellar: :any_skip_relocation, monterey:       "d638c0bc06dc764447ec0ebc58c22e7a614fbbb799ab1479bbd90a30526132d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "199189e6539af56cd44955fc153025220f00ae17670c83e1e852d27c021de9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badb528d646cae0a74f29a87b02ef3990057d875ed0a919f2b225f264cf92e97"
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
