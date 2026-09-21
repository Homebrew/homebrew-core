class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.11.669.tar.gz"
  sha256 "c2d514e25fa0c7813f6905a0cac3d412a28bcc6823db834dbfeb24ad1f845d45"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c2300b96cd8d71c7270dce246085e5edbd4520673480d96d1cd25ed02e592aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f99ceabc0727b54558a6119714b7accc712fe77e8ea95ea79db2335dc5c98c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3becfabf58e6eaa61f81b0ee582b22216106a6b335610df3384ccd1b12b1b94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b7c2dc9f1c9a611a3f0fbaa4816b8856cd3e362b5654c15e0ca918f4925ba9f6"
    sha256 cellar: :any,                 arm64_linux:       "7a6790d0a6b699feed0a9c23c1f21b20f8a1643047cf6fa6d8e2333a25374f68"
    sha256 cellar: :any,                 x86_64_linux:      "0e17fc72eb974f18922832ce415195ce3106e5e888bcef234f9956e60d56651b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    tags = %w[json1 sqleanall]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
