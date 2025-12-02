class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "0b5244f8cf7fa30ffbbc8c002c7b3999cb1d0e1edcf2de8fb1f244784c7eb86f"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f4d579bee4cccde989b5d4ed7335ecd8499b24f23a0239496c9e0f89da4f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "214f7a3c33ce11a61f00ab51f67addf9507fff01696d7640383fadf2c8391ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1decfd6ada0d3f6839d60c76f12eb91c3457b48d591738f8e74faeacd134e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9f535a91e3f234a5b4ab3223141f9910a4ed4c4265ba047f8dc02e78e33d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8deb844ee275e895f82c674a25e2c9da376a7ae9260106b41334dc6881e2f7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2f79f4de9b04b5df7d7ec39a5dea2a8bc2de3b2a840c1fe451b6f902fb5528"
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

    generate_completions_from_executable(bin/"regal", "completion")
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
