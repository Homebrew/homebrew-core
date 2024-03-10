class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.591",
      revision: "9e5a9d67bc14ee479e4250d9b39efa28f44730c8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef36ab292a13ff55e2789f0c165ec62ba68dbb329cb4dce98cf6a0223f0aeef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a08f0d7626fb7286e187f0a2236f8f518650809fb49871d80497330f57e489d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b593d732a1640b361d1ad6d79fbb08a2b410447a1486387267906d33101e226"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7bd733deb5dddd52beaf3d007b433d5eff79d18a0266b586f46106c79c3d8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac8e14ae9ddd87de1466d88a06fcf23ecc90fdc2e50af665b3184cc058ccb21"
    sha256 cellar: :any_skip_relocation, monterey:       "62c32c98c6d1064aa00991110ff210d9687a0a5c252eab5ba4c87bb56c4ae011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47dc694eed6d0a76d954f3958f91aa0cbdb74f761d131e05c676f84432e4790f"
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
    system "go", "build", *std_go_args(ldflags:), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
