class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.15.10.tar.gz"
  sha256 "b12142db932eb099dbb66b5e4744915b93230d76fccff4f5672d54acd043787f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627b87680c35fc8bf41c18d98f3bb19636b8766f30ce97f94758136ead21faec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f383f3513fe3437f907fb3597d0c689bbb0a52a5797e4bb2e66be1717a091110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ec351fb73f991df0999b159b72732465c697b85e402a56ffffc0d9fd4627473"
    sha256 cellar: :any_skip_relocation, ventura:        "b3af7c347a1fc5fc44a6ed3ac0388d7533b551b905f605b35d0ef3ba1376d203"
    sha256 cellar: :any_skip_relocation, monterey:       "043f112069aa2ad435ec5cd47170167e6a8d97a47e4c2ff93ce1bbf4a8842e6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "27c651161295658fea3dcaf309a51cb43d76c50a0f2a2a22f5199520e19fc8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd3ecc241266548c4c03b972b2d32b663baf458a3cdc7cd3308518febe31546"
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
