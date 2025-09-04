class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "080b72e4b5b7a59b509fa162d2d86ad7c07bc4fd596efe830231923dedfcdc39"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf22f99f231b2006e515d7029996babfe3ed2601b3ed7e62761a8b23c3950c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0929473554db7ff4c32af19b6f7877f27c97518362fec9d32bc3f537696ded3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d6730608a3591419825a5bc36117414591e3e08eb8d5c3f0c696253e127ffc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2b5881dfbaa3383394c073626fdc8b0dc4bfe9aad3705be9cb8489e15563305"
    sha256 cellar: :any_skip_relocation, ventura:       "753c91d9ab518720e5b4fe949a28d2f4c458e38aa82c9c0aa820b6beb718423b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a4afe83edec326faf2615a3e252ce9a6dd7538bf37156c97e1160f6bd87412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2eaecbba590419d9879c5cc493c3789d6112cf807f3a9959fa125c426520334"
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
