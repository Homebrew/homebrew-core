class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.547",
      revision: "124f300aa78cd9199de84051198eaea46b897cd7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a8f5c6a90df53aa3c34acb7d181bd80978dbe570d0da029ee0b54c524b95336"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "815e4e3e1fe0e352b2fb466c8572db5935302f21120171116d351c8d3d6e5d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e99d16a4eb50175b17dc4f8d4747c39dd29c8913fe3df558872ecb3c4db7340"
    sha256 cellar: :any_skip_relocation, sonoma:         "62989bd8181cdf09dfc6cd0225d7de0218d7dc8cdcb6e082551863457275654c"
    sha256 cellar: :any_skip_relocation, ventura:        "886dd81ad25251ac1d22a27a0244ec474202f836f9c0d67c413888dade3c9cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "8fc584485fa61fd7d3ae129e3fa0a79b8fee02afdbb5bea5282f8a7d70d0f6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a12743069d6c4c3f4a3dbfb2c27e602084acfca8dc9b4bc4e2218dfc614d21"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
