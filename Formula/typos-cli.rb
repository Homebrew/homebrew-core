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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c54b0dcb814f3f6e85f55820f4dea78fff44cb05f6d2c1702321b46af8c364d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "443abc69a459503ca1fe39432be7c83a94cb1bc692dc2f2bc3a50cffa4b40fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75345550c3514e399ce42b2ec16da156665c63907a91ce2e50690cc068b0d739"
    sha256 cellar: :any_skip_relocation, ventura:        "4072f103f6630008f4d20bed261f861b719ceb82974c42b927080accebac254c"
    sha256 cellar: :any_skip_relocation, monterey:       "6b6eb8577f49054bc4bf7674ccea8cfb7798369081e1f778d75c6d40cda94b3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "68aa3c5e71ea5b3b573cf4e4411115f01272e01970302ed3c94ee5346c1565e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71c7b241bca02c76aba379fdd28cc1e2de1c065a11bb658397201ef88a60661"
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
