class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "475acd61bff0b6ee4ec58aa566b442355e88d9efe18267c58c1501f3fb93f4bc"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69a89d22d620589197a0d171fcfd9f43fc051bf5c9327d6d6b30f3cb1ed37e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d28b3cab440b33149ce174545b7452a7913896b09ff1875cea6a2f4114a74df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705408d42ef5cebc82f325123dcf12cf11b574d8b8cc0fef54522109e78a0074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b3306cee6b182cc2fd1655b10f1cf19c92105acd1fff6e317d2e15f1878ce9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "534d9bca4bc47cfa794bc3baac97d1dea93bccbf3b2ed9289e2dff07f6f17b25"
    sha256 cellar: :any_skip_relocation, ventura:       "ab659bce1bca4efd0e3abccdfddf515f5126f3ce94bdf8b41121aa0a7b6dc236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e2f551f4f916d0435ecea589571f991a0b0a2b0701a39b93cb2fc857b05e54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "118191fdc4326752d6e790f341c440199d09e3ae431f58c0d865a1a5c5dc0572"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/wrkflw")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
