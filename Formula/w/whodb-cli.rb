class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.131.0.tar.gz"
  sha256 "509fd6f7b16e0189015ccd3d69aec4fc5b5f84893e1c2022e4e97a2337bc99b4"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "142ace3d3f523909911b7a9bfa1f58d00721ad22e5c1dba522adf9da1f6ddcab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f8144d181bb82c1512e0634307b1f64accd54c535bf1c8af9f7260008055936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b3625296feba06c1f98bc6032bdef49775053dbb589d6f467b6f164a01c167f"
    sha256 cellar: :any,                 arm64_linux:       "74130a9b84d1641301d251c512b9fd173aabbf8692d9dc17e5f7bea8b565323b"
    sha256 cellar: :any,                 x86_64_linux:      "8afd9122980666fa80bf7cb8d86a45df21415b79dacfe8c4901b1266a0d5c274"
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
