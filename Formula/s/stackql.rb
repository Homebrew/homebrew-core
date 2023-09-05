class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.418",
      revision: "13a9de3690aebad1390a6120d03cad8bab69e618"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a68ce26090d447b3fbd15963604a6737ab8db13a5422142ac2cde9be48daa4e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b1403a8dd067025c90b8dbd92179304c255eef639ba4433433269a4469824d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "490d49d8a49877ee1e5c6bd08d3882faaa511f60a6335e593c6063d9668d0432"
    sha256 cellar: :any_skip_relocation, ventura:        "166bff9749219e6127951d66f8526318069feaaa1257805de0caff98923fab5f"
    sha256 cellar: :any_skip_relocation, monterey:       "caed62dc1c140e1a3e2c86bda8c81701dda679644e1ef312b22fcd9530f8ff3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "aad3df8283e76fb0550a204d4714eee60197b7bea7abce647257fcbefa82e20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "331c4c5db43d5bbe986da7f7caa5ffe253490b5d251ef10f5f2f7dd354d6c493"
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
