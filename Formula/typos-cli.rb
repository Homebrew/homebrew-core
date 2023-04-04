class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "4265451a6a148b318325ba932634b1d2937b27294a767b66ab8e8a937feb8a15"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac52c63378c89c4ed11c81f71e69a15cb7555973832c02edf1c6fc0f8276edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c52aa20dfb0b23081c62feb05c21ce1d57e229b33be717ced785017bebe9fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe2badc203e2cf5dd286af03a843b03e4817d3a769caa1127224c07c4aaa314c"
    sha256 cellar: :any_skip_relocation, ventura:        "4dda83e28e5137ad5aaee677652b215c80921fffe6218fef8cda3814d1197487"
    sha256 cellar: :any_skip_relocation, monterey:       "926a9a0c51c019c5a0be18d09aebce81cdf005b39ece355fa757daebc23ea4b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "55103bd0cac6dde4cc593cb4de3e0ec101861a2fec67108512e72a021bd08898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5292ba151a79b84843881d5bbd60d3dff0c628a8bd1ce316c79a29d038fd7bba"
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
