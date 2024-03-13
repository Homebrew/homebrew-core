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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f23fb98f5c2970285713bd292eecfbd7fb3327a43cb62ccc965129458dac1f54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "910ace15c39815f99b523e6efecfbbe881ee465d05675dd427b87542ee3a7555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9678175f8b966437d8b07b13f4898f5079f96983a4d77c0fd61a9fc7fb65743"
    sha256 cellar: :any_skip_relocation, sonoma:         "8847fe666648dfee29d4209334626b7507afbe3bb2288501a358882bdd96d5ee"
    sha256 cellar: :any_skip_relocation, ventura:        "bb83d20d5f9981372052a154c83e0d3c6f0b7774a65008e4b77f0b5720962dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ad3e22d105be57751956be633bd5fcd06535973ce4f62cb86366803e88b0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daecba4185be33cd7358a533d068b21b5108b672e3a66e8a56a82974380c3ca6"
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
