class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7ecb4085536709ac888126c15449e08b8e1b26185090f4d230bbd54e2b84362b"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    manifest_sha256 "50c1d20f2b49919c241d3ad7f853e2fa9fa7d980606a7e72c2c71273ca0aeab2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c5bc14783d275b38725e0ba27effd1be2361127d23360cf77af43587fc73d16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "393f0310cff8ee862ab8efcb9d9429661a103151f128d65abbf8358d39df8a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6b71ed1ecd8eab78754f2b0881383e457c96dfdf67e4083e2c2cac96b2b0e14"
    sha256 cellar: :any,                 arm64_linux:       "1c01229e1e7940575161e8b8cfef0f188698d5a50e13e8a7b951d4536c7530c6"
    sha256 cellar: :any,                 x86_64_linux:      "fc681ecf0ede8d6f60e06b7405b431e22ab30b4542b68ff8f209c7b9319c692b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
