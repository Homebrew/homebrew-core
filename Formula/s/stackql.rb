class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.652.tar.gz"
  sha256 "6a15678dbf2acb64e4f998cc0e79ae284e1fc8271189b2076afb0d9e70f112e7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6627e4dd72a99e3c7f2369634f3d6da49c0fedab31823ebca70868ea8e2d87db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7f3479192315eedb8cb836c66c7b0ec745440e92d87d3657c782af59dfafa18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a4faa81b7d97efe31c9061cdb1bbfefeb1e53e8a9da0f7589747bba51a36b56"
    sha256 cellar: :any_skip_relocation, sonoma:         "58fc9977d5174f6b3f9bd7a88ed0a421b70f4a3e7bc2c9bfec8af3bfbcb0aff5"
    sha256 cellar: :any_skip_relocation, ventura:        "16c29a023bb6745e353fa7912e69709293850bd1dca0177b0fbfb89a66965272"
    sha256 cellar: :any_skip_relocation, monterey:       "e79ead1928265915947f27fa726d8795807d30fc143c3d896c08a6caa60059bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8f0a189db4493261b7add286e5b7293d0cd569ec8f953c3f11a3b7c3f35dca"
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
