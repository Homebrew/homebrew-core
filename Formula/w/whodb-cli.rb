class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.106.0.tar.gz"
  sha256 "e99eb0608d4c119e2a66aef6bc1f1896331bead27669a3120812bdc16ebcbd14"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5264367167f07fa5cb437f2de27cb90b8026b725aea124541c4cdeee65e69b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf67b0f54e5731b2d8f5c2c066c2ed7b98f4d145352454a0c45b443f29ed28c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5927202acb084c0dda67f53b5386fb976d544e74167b98f73ed3a143063ea646"
    sha256 cellar: :any_skip_relocation, sonoma:        "a079a9a5e0237df659fcaaa51fe7e0c3b3d9c8f17e9c94fc1f1a2e6475d2beae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04cf5a1a95c763f99c5b7c227b7a177ff319a0f7bef0af50cc7df77f32bae25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3844d1a98ae0f51c353593a0f263133699b77d242c0f6a67f0f552be0cc100"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -s -w
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"whodb-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
