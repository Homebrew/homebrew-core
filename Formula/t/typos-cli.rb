class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "4593f4191b3f54e5793b3e398524923a818ed66af656bfaae879f7f967ccedde"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6871612f44e135c544e84f4197beb1fe7ad8e9f79cdc91045a9270e4faff6d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad42119a0bdd63474a176868d051786e39c2bb6cb48e998f48b7b156eac2d6cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c572320a8379a81ad0dc915a5e05876229f26a82aeedaa36a7a833df47069d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcd697edcf8a4839eebafb9840b3c63e46455a72d0016a901807c43b3c55724a"
    sha256 cellar: :any_skip_relocation, ventura:       "f29a10bad4602c641330f6baf2cff076f14cb532eb136dd31982a59e337c1e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47fb3f7b7b49042ae856a7e25a0c1ced9a2a3d39daca565447300e8d1835b0de"
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
