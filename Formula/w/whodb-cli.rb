class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.119.0.tar.gz"
  sha256 "987be41fe89214c7559fdea70f9e5497bfb2f2fe4468e6ae854c6fde0bbb6862"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed1771316f6e58bfc68a25aceb966088be3a5c47df08e4d872a2f7be9f7548e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8721f4ccc7fcca6d6e3dc8e906f929c1c17e836a281509db31f56d12c7aec2fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d311d1f2e713cf0afb8ae09d1cab3f8e4461b9584e580ab69e37e619b58b50c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a869544bc272268f6f6ede029fb4e1f326d184e395559274d057b62ac41869d"
    sha256 cellar: :any,                 arm64_linux:   "c8273bbcee5f251884e07d686b6a11fc3715fb1cea9bf8f86c2762fd9d10cc64"
    sha256 cellar: :any,                 x86_64_linux:  "569eb424057471fbb16bae0852b4a7812a484def7768177476bb5f5d887fb7a1"
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
