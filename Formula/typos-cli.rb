class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.22.tar.gz"
  sha256 "0589f38185288095fbb2198f7a957eab499407acacce04f71a93aa54c10dd56d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "084271b6d512f9abfafc35f2ea22529bfb11a99808d1769c02d4d01ff32c6619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5f9febd337a84d50092eeeb513a749e22fb9cfaa758a5b4d6e3a5b5504071d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c137faa522823cdcedb33a8f6c31e952a7c0ca480025b1a41d0924d4fa4a6efc"
    sha256 cellar: :any_skip_relocation, ventura:        "28ee4f8385b5d440c7f75608656630515f2eba96025461640a0daa10064d4721"
    sha256 cellar: :any_skip_relocation, monterey:       "be23090f3fe9a2b0d8e32aa8d3686a0a778ed4de6d8ec246b5d0b33d47ee5e39"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7dc9488bee78d1710099c0358b54088d4dcc47bd623d8d7d7694fe02d6fe61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0edceb2abc48c2afcd9802e88271816e55f85f0c7be92e6e1c311c03983d560"
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
