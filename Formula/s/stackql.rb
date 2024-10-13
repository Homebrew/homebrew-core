class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.742.tar.gz"
  sha256 "f9b5534a0a38720bdc01c4d2203734df2f2b39fb433aa06eeaf10eb455163c52"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba898276e24e0b31b50f28d1ada18dff1e412ce2d9ee3a7ed30d3eaf9d990f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c317ccf6e7167d440d740b675b8151e6c727ee6f0ccfc9206c1473e9108dead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d739f3e4986cedc5cb13f79cd576c42f130ab2ebc3844a8daa746d530c1acf56"
    sha256 cellar: :any_skip_relocation, sonoma:        "616cd95ab6593e59fe6aadc012640ba80930a803ea679b8e21c4ecefcd26839c"
    sha256 cellar: :any_skip_relocation, ventura:       "f9ec397155e8e3b5cb03cef142fc50d30a8974a533fc78488e18b9f7ec9a9c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed879699c3d6060787a487ff0a7053e7eb38bdf925b718ad8e9e4981089379a6"
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
