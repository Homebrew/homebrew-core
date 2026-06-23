class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.116.0.tar.gz"
  sha256 "5cab4d7563b88facef72a313a0bb460acae3322302dd532225acd16135b8098f"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca43f81c6aa582b40712089c6ec8f78d1f9f1e81d222a980ef2d4b479c16fc28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc561d45ea94d289d89e76ddc5b74931205eedf347d4b130ec09ab28370d661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e8795cae96762ce9fda696193def1a018f7248d7560bee4b79de9f4af8b046"
    sha256 cellar: :any_skip_relocation, sonoma:        "169d8597fb6f07f34f3ad0f74581e1bc1289d8367f8c7897590afb0730cf06b9"
    sha256 cellar: :any,                 arm64_linux:   "09239985e1ddc97a845aaf60aa519b028e0773dfb3becb708754d9abcf4ef8de"
    sha256 cellar: :any,                 x86_64_linux:  "ce7ddf06229fc1ad538a2e16389609363ef4ab1d86c12e1aac9f0cbb7fb1d23e"
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
