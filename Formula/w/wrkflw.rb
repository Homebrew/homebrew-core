class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e145daaef2d52f685de41021151dc7a213e5cc57ee78157bb171200d5195467c"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd291248574e79c2d6b4d3faa1c2ed63f7de3dc4c617660e3560c614c896f648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc3440e7429412c80b0006a3b316e6f44b3baf82ac967a6ec4187860879676f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37fbe3ab828a1bd4636a6d46cbc59dd60c571c1148853a4638bbfbd511879840"
    sha256 cellar: :any_skip_relocation, sonoma:        "237d68af08d76e4b75d2a115ac62befea42ef8bf721f8385595edf40c2001a7d"
    sha256 cellar: :any_skip_relocation, ventura:       "caaf8bc1c726be42eeb690dff72f9de308bbecde8d6a122335a5cdc440215e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4923bed91fc57f02a4d6bd7f236920d00a02a154dd13e689183d9b0c88cc5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4487926f2f14c821971a788045f5bcc80bd51a5a23452aa7ecf42fc4f94d7f95"
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
