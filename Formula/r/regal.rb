class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "6ceaec611652af634cf9c8384a322af74038c1c8b874b5dbc1da350ce4565797"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec6c02fe7011597626821c8d2aa93693e857b9f622339e8e114c87f72c9f891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec6c02fe7011597626821c8d2aa93693e857b9f622339e8e114c87f72c9f891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec6c02fe7011597626821c8d2aa93693e857b9f622339e8e114c87f72c9f891"
    sha256 cellar: :any_skip_relocation, sonoma:        "39fe2905bef26492872ceaba4e96669a44ff0e2e5c6f8b21130b63522244d12e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14bb6488833bab5cfb7995200c9e549a3e68e3b7c9ad2da54c59cfd842beaa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e169c07644b0ea9af9733e45d1668b036fb1db015a2d13f99b799e6878addbe1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
