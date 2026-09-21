class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.129.0.tar.gz"
  sha256 "b2cada31f6c2b324585572b00099c7cee78cd1d57eadc2a04cd67dcf3cd3b046"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a6352983afe7cb73a7d5758b596f90ae65e90233353af63f13750bdbedc6297"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd705ab87cc82f4e0ad33305687f7d1fa9549cb2296c5209767f250c62a37a68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af419fbf4fc44144d57a825f9ffe56b4ed0a1bb0ee2a2db6c2006da784b86c49"
    sha256 cellar: :any,                 arm64_linux:       "56b4df808553be1bb983619b4e1c84abc43039ad5a428366a0cc0e157cf14334"
    sha256 cellar: :any,                 x86_64_linux:      "79e5d7ae4eae5873416ac393e449889a7cd827f24bf3f693a87762a5141fde5b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(output: bin/"whodb", ldflags:), "./cli"
    bin.install_symlink bin/"whodb" => "whodb-cli"

    generate_completions_from_executable(bin/"whodb", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb version")

    output = shell_output("#{bin}/whodb connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
