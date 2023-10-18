class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.474",
      revision: "fe9d42716dd8a54d09fda7dc3fe89674934737a3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa7e2ff1c855a4c8e122c47cb429b2bae149e2392ec09ec6424e025922cd388f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fbc6cbb4d3f2dffe6ff2a432c5c89fb46ec37887e638c0a1be1d377f2f15cfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e70a6c5d4ca19e4a0e146b217051c94010bc63aa02dc2df87f2217a134175305"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c178473350aa580ce2a48e8530781d24d5ae03083044695a5034c6db1c53fb7"
    sha256 cellar: :any_skip_relocation, ventura:        "e0269fed8c1b8b3592b1e92e3439464c50fa6e8e1dbec2c008911672f7c709ca"
    sha256 cellar: :any_skip_relocation, monterey:       "0f9006018211b0b34ae3f1f29ba39a088fca3f1d21822c5beb7bd5f2d8f4bd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efefdb8218138409973eac66ca316570fc4b86e1c6e1c1b1e825f5091a8503c2"
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
