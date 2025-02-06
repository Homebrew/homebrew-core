class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.6.65.tar.gz"
  sha256 "0866d4f25c4a2e8e013f8dbc2c9c6b246adde76f273364aa2ffaa9da7e39b2d6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "978797e12d3f511ecc65574dbcbb5b55c69b1b0aea6700c39b26253ce50cac1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "332490b5a740a8ee6d62a0a2646a0f8c367cdd54f739009e5e9bd79af2dd5c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d97b0dbe61b045815ed32071bd3b4ada56eeacd52b03b82f73fb92a55b5fe1dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee41f2323cb21ebc22e0b1181f402bb8a5944b901538e006b748e4be05331de0"
    sha256 cellar: :any_skip_relocation, ventura:       "300586d20b95617e2ca9e5f90768e57f22f94ddedd7357a52cec6c39e7c4c01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fea8e3a64328ce5ae7f27cb7eee7496b5ff855c1f0f77a340032aba17b41ecf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]

    system "go", "build", *std_go_args(ldflags:), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
