class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.109.0.tar.gz"
  sha256 "c11fc72d9715e64e1fd0badf132ecca877db7b55f16d280af59e0236fc8f75ee"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f1289b599dd05854eda0cc118bd2823b2d05ea06115a8e15c36f6d9508eb757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110f5e9b47aa41d543249178738d2a1c5bd40e7310758cf77f1c94a34cf0857b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "643927a4ea28595ec0ebde91edd05c71d30fb50b818149cb7995f519d6d50c1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "23048cf23252896513118b63e6c837fd1f7bb5043ab318ff19476fde3e3681f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1694eca5650976aff03d0f6f73b0844c4fa4acde3c3a0f3bfa9afb054b8737ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46453e7d8a488ac9e7337242f201319984813fda268ebc6b988a63d2f4d9ad7e"
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
