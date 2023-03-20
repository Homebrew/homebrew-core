class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.3.293",
      revision: "d739e964a3f7ab917d774dd3fb6beb091abf2342"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ff42b6e99094b602a0cb69dc88d812d788881c7d0712f2392bce44b284956d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75758a75e17f80bc559360dcdf3ad2153bafae205f3a725bb28e5a45b3dc1b1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cbec1be92ffc7689b6fa422f38e3c5984f2a40eaed8ce3ce3cac497a02d2c0d"
    sha256 cellar: :any_skip_relocation, ventura:        "6ec0e0088f2d3f3b4827060a8208f1fd1905ce5b75ab76a27e66842fbd12cd52"
    sha256 cellar: :any_skip_relocation, monterey:       "f8caaa27dde839007261744bb887e7801bef45456aa967ca1663aec278e122ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd52a58e5765a41a13fdeaae32718e35a07e065d5b42d4345a47c1cebd2aba23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c55f0bdfea0f14a96c3bed374e518e80b31ef3a94191c97a93ae3e8fe796c192"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
