class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.748.tar.gz"
  sha256 "362a42ced18addb6ef1f7fbb6647ddf07d60bc58f3a32d91a380a2fd1e6fc296"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76c9444f3885e3e43add39558f676f37694d100018fbdc1b66a4d189c46ee14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93ae48058cfe333846a1fd491be2b4366e7140a4b6a0386e6361e7d26b86cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a2f9b71a05baa6b3de059a1465786e4291d0c3d3af95b7dccf7dda7bb41350a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e03d1c84dd91b72ba7dda3af35549c13d22ef4ae4bc3adad9d7a39736b87a76c"
    sha256 cellar: :any_skip_relocation, ventura:       "c93a63f07891fd5fd59f15002621d78e69d0e5dfcd7a6072e943fba1ce1de423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff814a007d459933d04382de82975f2dfcb725e4c9562167d7c2230469ff2e7e"
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
