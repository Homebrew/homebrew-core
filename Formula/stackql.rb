class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.375",
      revision: "12f263cf32b06f2ac13d45ef1027ce63608a5224"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cc0997cc90e7a67d6b8599ac9f955daf752175c57a712fa296906694dc951f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "650ea85edc3288762b709f28b12ac80c66aba034f2b5116ca667589eb8b989c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bb7033f430edc5a32e015c120ae649960080aab4af4c8d137c8ae0ffd852f39"
    sha256 cellar: :any_skip_relocation, ventura:        "efd35edb85747d2cb2ddc672c53fd265a565b50e007a066824d2f17fb2d11b9a"
    sha256 cellar: :any_skip_relocation, monterey:       "c3611668e1d1389917cec1820fd6ab4c5f69a4b77c08155e5c975e62203b68ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e2fd1754f15d6bdedc64e9bab5fd2ecec2f1e5ed6ed4a93a9047e9183cc9724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd917998b1ad98c2410493bf4770a36f006e6bbd8eabcd95def6f8a3c16e6801"
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
