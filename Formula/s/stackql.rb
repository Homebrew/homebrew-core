class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v1.0.888.tar.gz"
  sha256 "69007fa7a2b2e742c26e671a668d7f56e6ba039d0301488092b5080132f129c5"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b79e953fe2a8f4f7ced6ff750f25fc187b8ac7eaa1296c4b92c2f7ecd4e42f60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b79e953fe2a8f4f7ced6ff750f25fc187b8ac7eaa1296c4b92c2f7ecd4e42f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b79e953fe2a8f4f7ced6ff750f25fc187b8ac7eaa1296c4b92c2f7ecd4e42f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b441dda86b95000ce070b75cb258264ed0f75aaf93d1d891a39afdbb50ccaa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "337e17cadbc6ad57477f652db0bfd28b12e27731c9dcb7674fb075975b030429"
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
