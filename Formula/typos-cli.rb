class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.24.tar.gz"
  sha256 "44ce214ee9ec4f6921fd7e713ed9e351e7b793e73a675e6a2026ec769cb94efb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e30cd655aeae6c49879673aeed447ed4e79156eb29c838abc686c2beeab82f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9c0a689d253fde391b5c11eb2c9c2a79b76bf6026717333beb0cb4c64f2cc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e36e4d1a365f9ff50612e75362ad890fbe9b475b434a1385b330e5475018f5d0"
    sha256 cellar: :any_skip_relocation, ventura:        "3b8ad6671cf67b73b434b744e9a0e89978bde69bb786a788236a8e1dbd0cdf76"
    sha256 cellar: :any_skip_relocation, monterey:       "98fbbf2c907ab0c9c79a2fb4716d048445318ac66151b89044e588d7358577a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a5b15d8e77b4f4dccc2cf518ec6cf71907b251dc1cdf5096df66a133061827a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff74ed9fd74f9e17b84dd44101ead134b292ecb6da03385c5e60121e47766bf9"
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
