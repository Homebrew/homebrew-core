class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.104.0.tar.gz"
  sha256 "9e40840d938bf4d09e6af332d44b3ba6472691881ebcb401f4e6f6c434e32aee"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c229af2f46fbb0118f14cc6aa73faf7acaddc8b2a0a8525e55835d993aa4589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb25d16c2f8c794c2074468ee86d4de8b03b625ccd261d6e9ee290da9e8cc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e46184f35f0159f3f16e46da4b719ff6a3823c609c72cb2f6acbd62e0519d2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "73d897118d079d83ee9f1f43fa08f282bf092926e99a6e4d3b27b2df2293e96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7202e5a6fa2221a91043eaff42ac1c392ca21bf5e91b555bb78390bdbe2e558e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3d0642477e78e4d345e22b4155a8215c7c19008a424f8bd045113680d95106"
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
