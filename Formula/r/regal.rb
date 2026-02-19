class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "6ec8d93bea5f9b3cb311cf53265b51c984107a8cbd90c102dd2f864107d776c6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ecfcecc9249b6b4c689d49604d25f404c8a72fcdeb1f85ad2ad4096b4668d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9abca1e34f538bf660941ca0e9b0a7208f03ef9ba031b96bddfd3fbc8fd51d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170766f51f52f81238b902b0acdbecb59ea83fc30c5934cc404fd98b760051b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e35e5fd3f804e91f2d72c24a4ec606a5e2db55b9be2481c8077cd8d7569b719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3641d06c16db42073a3c8b8cc2d87740247f91825ef27364e7ab1397960852bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6d4399d51a1fa2a42b4d85a1ab97dcc8a249394096dd2096081e4706a92270"
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
