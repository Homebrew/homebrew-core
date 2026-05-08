class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.107.0.tar.gz"
  sha256 "cbfdf71c2be1fa049b869ae7484ed10b8081f11310ac8364d4504097812d2a4f"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bf7825da9ba748fa7ade41046a184afc20ed88eda7a6e6e9af14c9dcd81775d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e460685dd9082d68e8da5483a6595ec9d5b2ecefbdf35cc25e4493327b8f066b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1bf03dbca04d73f2b73de6a621c6ece2f7b8cd18653c83cf0d8961e14df65fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8c2366b0f7efb2c87cadf3852e28ef71a44ed1d9364f7528140bfd66dcd7cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9983442da66cab32d1a5e94242b230961c77318c57faf25ec5e7063762898ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dca217f077f757c7e9f851e2660166026eed09b347d022df3c32dcda8386909"
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
