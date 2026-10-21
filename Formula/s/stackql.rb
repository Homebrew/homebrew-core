class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.12.778.tar.gz"
  sha256 "0c04201c31bc42a7cf6eb8136dbad8d2415036fc56b19cd1545523080743ebd9"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d0f1b52ed08df359d3ad8928741d49e640e0277c3411392d710d779f32d90d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d0f1b52ed08df359d3ad8928741d49e640e0277c3411392d710d779f32d90d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d0f1b52ed08df359d3ad8928741d49e640e0277c3411392d710d779f32d90d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "744e61f5f9d2fef54984c642c315ba8f36a1d8a4845d52feb5fdfdd4cdf43fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ed9a758044edf01ce712ddfd120d5c0d275cd2d77f7ff6e4efe3d35254614132"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    system "go", "build", *std_go_args(ldflags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
