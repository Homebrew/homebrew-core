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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d9653de78bf28b90bc45163c4b6043606ed65c89228a09a323164b0b32238d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d9653de78bf28b90bc45163c4b6043606ed65c89228a09a323164b0b32238d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d9653de78bf28b90bc45163c4b6043606ed65c89228a09a323164b0b32238d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9513abe735b83249104f0d421b059297dbfe6d4bb5acb288d31f0f729f43c8d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3973966a81946ae97f8c157450e34a3ede566622d2ce0291c45fc8460384aeaa"
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
