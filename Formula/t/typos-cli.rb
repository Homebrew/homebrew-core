class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.10.tar.gz"
  sha256 "576a0fb8e5ea118fe03888f125a61396fb7afb60bb6d5ef5dd53b656bfb4cad6"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c1cb50b68b3bd23102f763c10a7e977ac91af6aa80ee7704ce6caaec5c4f5ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4e336975fae153e4d3b4b5a8ba25e6e0c0fbcf6f07f4ff787a59d3cb377cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164526e81414407c963382a2b948a4d08b21d914103b09e4c8716dabf5dc9935"
    sha256 cellar: :any_skip_relocation, ventura:        "3b99ea848dd88426827f0377116c74e70dde36cc600cf3d59a6f47942ae6434a"
    sha256 cellar: :any_skip_relocation, monterey:       "86172eb33375e732329c32b013d25b9aeff6a5ea9e1cea04599d2b23fd9c87ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cbeeaa0810886405e8a1f1ab1fa4802c9f35aa1072133bb30076f3f2c9e12a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fd5642e06dc8dd0bf44abba8c7727004d8011fe40c188457bd96016e3024d6"
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
