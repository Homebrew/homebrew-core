class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.612.tar.gz"
  sha256 "f35e7c00e024896dd1480b8f1f53847beaf64b49a2b6c522fdc054d0c7787e61"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf5dd40f40c7265a5e5a6186a2a5510165838541f4275cbcb798f5af5d85a91c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8836cdb2f4a3d46a266604e2455fa3ed7f15617aacbce9444adb92ae82f7688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98eb6c3ad1fb46ad041f8fafe5606807f9d08df2386a9a4192ada0868a6ff1f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1925014ed569afff17f87871a16b556f3ed34cd9fa49af5de9ca1a73c5158191"
    sha256 cellar: :any_skip_relocation, ventura:        "e9280a89256ef49e7391d5637072ac635d708d21da5eb6805da5e2b711982f99"
    sha256 cellar: :any_skip_relocation, monterey:       "62025d13ba1f963c60c4022ca00a129fad032cc5bb659a89caf55c037dd67427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fc9f2e6ea72d396c90f6686182c8ed3ce17132926eb254cb8d3c734040ec4d0"
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
