class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://github.com/clidey/whodb"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.90.1.tar.gz"
  sha256 "4c76f44d9d5e2bb6c227c9881ab43bf0f4c55da60efd27f75780fc4f46e79e8c"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -s -w
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"whodb-cli", "completion")
  end

  def caveats
    <<~EOS
      AI features require an additional download on first use.
      The CLI will automatically download the required components.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_match(/^\[.*\]$/m, output)
  end
end
