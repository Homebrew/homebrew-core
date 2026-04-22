class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "79d63da0c40cfb884600b671830d63bb6cf143f1d8e65886e067a747491c23b4"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb510c7d241370e93571b8d7e07ae8f2cbba98938eb72b555a51702843521b30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a07e28026eed57778888ef2931f0de7fbc457b29c32a06a3534e3891d64389c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab8aa9a1619d5da6e9aa16047c2d477555cb320e44904f3d4b2139c9ea92ee31"
    sha256 cellar: :any_skip_relocation, sonoma:        "73dac532263f52c475726342d835794767bd38ebeaeca7e9ac0fdbc998860cd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb7d288d0c7ac983ae095ff16c22a7343b9754b6fc2695c1166ebcf6a430502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "859fb97c3f0ea564aeac852b1a73047eaf7d2b82461b6b787064b553795516ee"
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
    assert_match "Validating GitHub workflow file: #{testpath}/.github/workflows/test.yml... ✔ Valid", output
  end
end
