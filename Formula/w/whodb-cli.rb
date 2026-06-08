class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.113.0.tar.gz"
  sha256 "b94673f93e6d73e82f4251c7c3f044dd68a4435f50c1edf8f699eb53da1c9486"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174ccd04d2e12497eeef34d4aa2970ad404f635adb243ca1a8695e53c4a84046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf299291cf9fa5a78b47ffc7234c02e16cd9752112867d10e24f6c272452b75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7402f67dd62aa573efcb7a8ef9bb78b7fa582a38be765ae7368ce62820414df"
    sha256 cellar: :any_skip_relocation, sonoma:        "299d456f7765dde73391d38d654cace5a97c3092faff9e4fc643f60d2824a1a1"
    sha256 cellar: :any,                 arm64_linux:   "4db8da97b5f81c25696f0509e4e0f12f997809e7f773956136c5274ddd4784f2"
    sha256 cellar: :any,                 x86_64_linux:  "89ce920a74fd722e33583df7bb8880dc94529d36bf0ac8c5697f6379de9e8191"
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
