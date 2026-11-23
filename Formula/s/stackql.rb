class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v1.1.959.tar.gz"
  sha256 "c70f01ede8f88c00c0eb872bbea0c60758130495c5993a20938b7c239b30d3df"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "8d6a3287c664b54216e2157ac0399131f3e6affced3433f94cec53a958c57cc8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d41aa4ccecc4433f01b9469b22d7ddd6c376394843848bf454213ff868aeef8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d41aa4ccecc4433f01b9469b22d7ddd6c376394843848bf454213ff868aeef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d41aa4ccecc4433f01b9469b22d7ddd6c376394843848bf454213ff868aeef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40a1da786a5583233eeb7c202caff250f338de9414076bf11ece93a25032d71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b3e6b26feaa3f9f3904bb05d8ecf0555001684c39b38f84714078acb34d0bcd5"
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
