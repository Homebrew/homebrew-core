class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.117.0.tar.gz"
  sha256 "49fdb71124dd0601e1c2d3bab1e38a6eb4693064a6a4ab72196510f6b7a2cdf4"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "675fe86672901cd713c3dc74dd18e1d1413ae6007ba94a6f3d8c22e4be6f673e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3fc84695d954ab6f0ad31bfa2c564a8f13ded00cc4f12bbc8383da5b3c8d7d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f858b19e485b4af2f7fa823bfd80fd713cfa07be4ea3b794b46e55be735dcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb644e59db0606bea4173e3402f1d0252018121e139649fc6fef8e9253684fc"
    sha256 cellar: :any,                 arm64_linux:   "f42d36aaa760713a35f2ff293b1a4c28a7bc46382e88aeda77a20dddb37de031"
    sha256 cellar: :any,                 x86_64_linux:  "3266c9b287f768ce8b740a968f34899ebfe31d2ee31c9442fc59fddd2d62a8ea"
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
