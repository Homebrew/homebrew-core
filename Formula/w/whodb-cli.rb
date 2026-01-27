class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://github.com/clidey/whodb"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.90.1.tar.gz"
  sha256 "4c76f44d9d5e2bb6c227c9881ab43bf0f4c55da60efd27f75780fc4f46e79e8c"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ENV["CGO_ENABLED"] = "1"
      system "make", "build", "VERSION=#{version}", "BINARY_NAME=whodb-cli"
      bin.install "build/whodb-cli"
    end

    generate_completions_from_executable(bin/"whodb-cli", "completion", shells: [:bash, :zsh, :fish])
  end

  def caveats
    <<~EOS
      AI features require an additional download on first use.
      The CLI will automatically download the required components.
    EOS
  end

  test do
    # Test version output contains expected version
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    # Test that connections list returns valid JSON array (empty when no connections configured)
    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_match(/^\[.*\]$/m, output)

    # Test shell completion generation works
    assert_match "complete -o default -F", shell_output("#{bin}/whodb-cli completion bash")
  end
end
