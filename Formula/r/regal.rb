class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "930fad89c17f5398ce0416dc63143816b07b95bd95d067583f9afaf46a3ef91b"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee54dbbb18c9ae9dc8cb2e1b8600f175c04c4bbf65fa80627ffe3525d33766a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee54dbbb18c9ae9dc8cb2e1b8600f175c04c4bbf65fa80627ffe3525d33766a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee54dbbb18c9ae9dc8cb2e1b8600f175c04c4bbf65fa80627ffe3525d33766a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1593b674198dd97e49f0a73168e9a960765c3aefae7c57cbaf7a559771e37c37"
    sha256 cellar: :any_skip_relocation, ventura:       "1593b674198dd97e49f0a73168e9a960765c3aefae7c57cbaf7a559771e37c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf646109956a9a32f93c87e80e768dc85f909d9ba39386dc398b37cb18dae5f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/styrainc/regal/pkg/version.Version=#{version}
      -X github.com/styrainc/regal/pkg/version.Commit=#{tap.user}
      -X github.com/styrainc/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/styrainc/regal/pkg/version.Hostname=#{tap.user}
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
