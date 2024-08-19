class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.708.tar.gz"
  sha256 "d9e40c2fc6207547291bacd806233de297d8d3fb012690d06ea3ac804a31931f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ba8ed3ebdd5b1ef260317339c65cd3f4fc9bb29a3418a900f9621f00a6edbe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0848d694c5bb7e1ea1122e76b67419b2dae1f41be7c7a0b68ca72a9c2d5666f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0176000a4f67d95a1223dabeafff159906c261fd3c7013ca2db9a5711b641a99"
    sha256 cellar: :any_skip_relocation, sonoma:         "23ac24af8fd58a0a861e775055f147de475fa3c01648034f96dcd088064d73cb"
    sha256 cellar: :any_skip_relocation, ventura:        "4a22384c0d5c515b6fad133a2d8b13a66b87914dfbe88e75a4fca41bbabe6511"
    sha256 cellar: :any_skip_relocation, monterey:       "3292dfe2604bd1bbe343a4e76f884e03872b91ef176bf0e93acff0c0f8339767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ceead0b536b8a83580ca0718d7704b336baff8188d18590e0f39889aa5326c"
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
