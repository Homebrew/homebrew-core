class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.127.0.tar.gz"
  sha256 "dfa1207f62c7a78e2d796c395272932b443742e43f0faa30d1c826dfd07b19aa"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b6735d2a0fbc544ae8fe8c9b98c9fa8a433fad5d723117b7203e282660201f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61441142d843e483837b4c85b0f0c47e3491a2eccd1ed1b57eb8741c6b32a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4adcc5bced1a59d5004cad7c67b9bef3df256a6d714586ca0a75c24b8304f098"
    sha256 cellar: :any_skip_relocation, sonoma:        "0da5ae1dcec00c83b0b47c3424b4157d5b33176572e4d08c7865102f3cc73445"
    sha256 cellar: :any,                 arm64_linux:   "6321edc07407f716a3ce4f62a214422c4375a78cd71adfcaafaaddc02c039945"
    sha256 cellar: :any,                 x86_64_linux:  "610df2078f71bbaf9675ae7070547aca1edb26d539cd758bd50f88faf04b9b46"
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

    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"whodb-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
