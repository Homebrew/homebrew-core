class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.100.0.tar.gz"
  sha256 "dd79bb26433c60e2b7a2e6727fe7e053230efb14184df745202d5d22e59f1c54"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d4e1d632bdae6936d399d582ac90e1a704e6d1c133c01ef911bc3af7a2049f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0c18b63c0c53a3e5203828ab9ad29ed06e3b1e03c63ae44fdc592f4124cd4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8b4ee70156ce27d25281f59984863a3ce8d4351c52e2f43205cb22594d3602f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a245ebfd2a4de6d63773a7788fad1246df2a69737d00d6ff8c04db63b7e3c0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1f08b4dbacfd703cc03cfff8c490cbcd65820b9a573ea62ad61375e29ad954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8a7d7da503e4c1d7f6e47f0548f5f16a32b523115d42ec9531c0d0cb668ba8"
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
