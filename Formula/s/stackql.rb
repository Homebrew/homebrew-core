class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.604",
      revision: "39293f5ea1b1f69ab276fa149bf30d9a7ae643e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3ad7b97034a1cb65fdbb40e7a41b6802eac2b537164133a4a3c0de9bee5f929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91ca0dccf28130a12ad48b9d6144d38f4c91c6e196d5e0812c7e1a1e47f1254c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c2b01a5f7db0014234c56aa6f517dd80d4cf9ef0b5f7532796d987248ecd47"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d7eec8a067a83ea177e1f7dac460a7e508106700f6e142eae8d0d8158a45521"
    sha256 cellar: :any_skip_relocation, ventura:        "21959b5ee8caf83721aec6a7f1c7b6ab67f992029280c6d963df79201e5147b7"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9c0a30c2bb6592e909338f63e16e75d21b699495fc39ab6ee4458e8797deb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95148729bba063f686510f97eeb197f96c7e908cc229c61a987dba54199e7bd8"
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
