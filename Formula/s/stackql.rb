class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.552",
      revision: "c5f7a7e5ac66710192da23544e85951a32c406ce"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08cc994ca99beae7ad4876522b4c76a56a8c6c79f239fb5ca114cd3e4718b0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9315c3592bf3d1d8bf74e1cff207870f42d1075e185d0686ff4662075260f83f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9885de2cc56e83c68a435ee482d1abd62cad616cfda17a330fc5c646f3ad4715"
    sha256 cellar: :any_skip_relocation, sonoma:         "00e92faaf6a4a5b5f5dddc0d96fbe4289afad1f82672ba82c32bd31e5580c5ed"
    sha256 cellar: :any_skip_relocation, ventura:        "bc068214e7455a5e13551ec6c233250a3749ce13617b3cd26835809f4068b9ec"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef8bf64a5edf32d7e2021bd30974024ac28557d93ceef23b310e3480a56121c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfac6eedbb504c5c5922313b98199fe6a201fbf4a517c493db3cdcf2ac0d405a"
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
