class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.587",
      revision: "5070cc350919604e05e921092416bf67266e469a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72cce726926fd31d1cba406ce02a3cebabd144096f5bfe1e66bea6a19ac436d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a6d066a1709f45adca04e96c4efcac4ef9ebf779f67cbd43bbee3fc0db2dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad55625cc4df2591a77e6f743b5b17f6532ac22c67f10ed535579606528c69fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fbf28f90bf0e81eb034652ae704c19ba601660fd09f5e3664dfd0af397c126a"
    sha256 cellar: :any_skip_relocation, ventura:        "e26eba460b39cde22bc377133f15a3ec9b35bd25736ae1314b00928243d2fd85"
    sha256 cellar: :any_skip_relocation, monterey:       "07d286386478b14b929f4f34f122fe6696f4ada99e787efb73a122204a049074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0699c55efd44664b629fb794749eb4dd4710a50e630ae78495868005094989d3"
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
