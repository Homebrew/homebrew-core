class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.105.0.tar.gz"
  sha256 "2012716d0dcd6bce8fef132078e070ade17824cf594a814357e6ffc38d5338b6"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e92c3659ea6df80c68030f0c5c0e57eb0afa3a171be70bd4f7d1f4fafc729d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0a391c5638fa2c315bb20ebbdada5ac9859c1bd8fc959794d2add6cf40e6fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6335b9010be0255f47f6877bfb504e619c3e1babc2fac1c12372620485669528"
    sha256 cellar: :any_skip_relocation, sonoma:        "0828ce92868547e9983725c4c881c6ade8e0c43eb24c6b7c12041b59eb05823c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d7b313c31370a3c39ce02ac610c392aa0e9987fd25d23008bf0324c20e02943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a7a806025d2e1e93f76899696ceabffebe6a3996763d8fa82cdb464562702b"
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
