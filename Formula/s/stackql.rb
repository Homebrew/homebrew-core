class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.665.tar.gz"
  sha256 "a78c74efe7b3063f694877eabf01e4165bb5a132e40087e655b80601cf782d0d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "629083b5db71ea5564514258479af8e1642c332975ec75b0611c9d9bb98c7596"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa6fb31c40340a640ff21c7469d6e91c4e6e0a84a0de0f1ecffd5784b42f1d50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d16545c77f446bf83fa252f55163e6eb0408ec5b21176c625162b665cbae21"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ffbc5d6337c1cf911af19945411cb68a1e31cf58af536f9611aebc3305822e2"
    sha256 cellar: :any_skip_relocation, ventura:        "c78b14bd666db13649976ba32aa7416644766b0289c47ff231b4ac5936d27f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "2f173a5ccbfabe4336b6cd7def1beb6b5151ad460b94ba4f50dceef5e7a53234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fae07e0a0633d53d1cf97d3fbebb08e948217bd6d27d48c1327d8a6a3061efa"
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
