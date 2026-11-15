class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "0b1d03ef26a0d4282facaba811362d2784c7bc0aed0a5b4df270b413cc0dc6be"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b62c1d88ad24042ef9c287778efc2a06c11408913e61c060ffc05ead5da6731"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b62c1d88ad24042ef9c287778efc2a06c11408913e61c060ffc05ead5da6731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b62c1d88ad24042ef9c287778efc2a06c11408913e61c060ffc05ead5da6731"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a36d61453505489408de35a841f03fe6f4511ad6705e35e1518636cb78d97b3"
    sha256 cellar: :any,                 x86_64_linux:      "7ca0a7c15df35c114483a97a55aa65c451661a6575e6897a82e1e468e8f6e413"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/open-policy-agent/regal/pkg/version.Version=#{version}
      -X github.com/open-policy-agent/regal/pkg/version.Commit=#{tap.user}
      -X github.com/open-policy-agent/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/open-policy-agent/regal/pkg/version.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regal", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test").mkdir

    (testpath/"test/example.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}/regal lint test/example.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}/regal version")
  end
end
