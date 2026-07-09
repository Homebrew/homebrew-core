class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "fe9e4b275af61c781403bc21d5b1841c573036372e21200ca7884590679fefbe"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1dce0c3a37effd102b7149fdeca327eb9d9e99a15c9a0da1baa815702e14482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1dce0c3a37effd102b7149fdeca327eb9d9e99a15c9a0da1baa815702e14482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1dce0c3a37effd102b7149fdeca327eb9d9e99a15c9a0da1baa815702e14482"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc3cf66523d9bb1b89d559068a259228e127f660aa7af58dd891962b41c3f1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ee3e51677cacff5b174d0120f29359f2b375c28b5ab9af0128cc4a15ddc1a1b"
    sha256 cellar: :any,                 x86_64_linux:  "b6136ab94722bda8abdba91efefa93db6b654b782bb72848708195a413f5d7e5"
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
