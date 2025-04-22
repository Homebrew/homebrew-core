class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.7.131.tar.gz"
  sha256 "c73fa05918a887cd1cc0b48bb460d02e8e5f2851f8eefd7b4fc19b6fe50f8da6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118b3df1f2a21ca37599d1ae8f42ade06561ed485de1f33814a9ab725b5ef96a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f85c1b8bd62f9bd8cef25635284c306b8d880d09ffe53eb1e0636b253b99f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "316fd3cc17f87270e9fbd8c3fc47bef9d026e2ba3df60c5035f0e4e477356f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e2bdd8d7e4c2d4b899a18482d116c9e0faa1a87513db8a2b89ff66799f65a3"
    sha256 cellar: :any_skip_relocation, ventura:       "e5ab941da843b394c2c76116812baeb04666821cc8f65047c88dee9a2c1b78a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6fd7fef7d1446b67f7321d60909af9e6facd1670519554610ee4cc9736d07f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f690a010baa9030806de520a69accefaa713dec447767e4a49dddbe813427f8"
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
    tags = %w[
      json1
      sqleanall
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
