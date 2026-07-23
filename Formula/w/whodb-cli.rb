class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.121.0.tar.gz"
  sha256 "3c98d326539c51db63f0e7815198a25b3f22c6f47d326931aa1acb77c46eedda"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c17bc6eb1dea5b2e9b679a7b18f622001b18e3834033fa532fa69b85868d88d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1578f1bbe54cec526b212b7ad2b35d4c1de758c4199bae8d8a212b8b4e554837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5a7f37cbad0088410b39941e26e7bf99c38e31ce8b82e3f15a5c80757813c7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "be5deb3daacec135343a8ad2b3c6b5878c93ace940393d1943f5bfd0bf9db8c0"
    sha256 cellar: :any,                 arm64_linux:   "819860316223528d6aa85dba1629ca6aaf7259ce5c763a914ce0724d66d5852a"
    sha256 cellar: :any,                 x86_64_linux:  "a53c1dfeab5aa41c895f16b90cdab76b91392b2ffad1403948ecd3ca667a409a"
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
