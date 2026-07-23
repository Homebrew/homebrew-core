class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.559.tar.gz"
  sha256 "7e75d9f5640f183c58b844162cdb0b572cc41554fa6fa8927babbf5e352a8d4a"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "560302661982bc964454acdbc2d45514422dea00ec06ea7219b9e7d5bccd8684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0ca1b3d5d40c79fe565cd92e18a6463fac90f68552e0ee253ef03488ef29f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49785e3fe2397738953c1624ea54bc2dd3fe22eedfaa358151f7295f5db2f2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6dd21e2bdc43979fa7907f658c8e65ba00f6d8db3eacf5a3c0d9abac6f18ff1"
    sha256 cellar: :any,                 arm64_linux:   "2d611a8cb40d65f52caeac8efc4541a3db4470c31d779fd1a1b8b890f4c89e77"
    sha256 cellar: :any,                 x86_64_linux:  "1612bd380a8f5f99a2d3cd186316665055b7f3767bedae9b3c8561ea71b1adb6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
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
    tags = %w[json1 sqleanall]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
