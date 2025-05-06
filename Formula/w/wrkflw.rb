class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "acb411e8e45332ab5808c7bea9d8ad55fe8d3a93245c4f3fd2f8b589bd55d9c5"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda57665e9111325cece0939ac667ce927f5945b3c3b59cb2ab039868c519d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "933c9f0399e670f8cf7d3d17fbc001e67b6754bb95d87503df0128f12858d1be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5548ae1763b6a8119af2961213f784ddf3a87a47fd43afac3c4fb9e585d8c1d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5a2a4ac0022921176d0a37478446fff19544a70eea1870821e278527edb62d"
    sha256 cellar: :any_skip_relocation, ventura:       "ab11aa86875ec9aeda886dfca876af5e9dda4f0058a392d9c9f4713ff9a5cd72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7090a30aa5830fea160162552b116a4c57067fbf211cc94b48662437da4c2425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64c3faa2554741e20b286734c9fd29ee44f57b0eb6325c8f7d68bc1e7f6557f5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
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
