class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.93.0.tar.gz"
  sha256 "33c1afeca642cd2efaf4ad33448cc91630d6970cfe272efe5ae57069a55ed50f"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "126820ed511ada44676b5a2e4c45bd0e5f7b61c8c31f41dd50229552f84a2b50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3a4e35271daa6f53ff4e5aa78030c63b77f6b9d1d236671088304b0239ddbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f55f1ad45541f92e28c95a53d1bc5700db86366d536868b0663ff701924af0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28f6b1a442de1fa56e2432d5e6c34c7dca4dff9b828cf9beaf751e255eff4be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a615ce4a62cd0bef5261f015a59baf5c89c3cde6d8d7db4a83a91d002e05c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2418e7f3f8db80916d9b1d43bb6fd229bae7fa5018cdd2c0113d76a83bfe9f0d"
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
