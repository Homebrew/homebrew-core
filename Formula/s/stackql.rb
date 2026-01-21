class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.9.339.tar.gz"
  sha256 "bae69713e69ee7c80efff86dcb2ea3ec5564e7d1879ae5c4697aedec91910b09"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad3d5d4e2be60590d1a5c2fbaf01772d437e35d423021f9acd9b7ac574ece899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d451913c26363af2eed45e4c3bf73c845137edf0785079ef1f2eb1a5e234091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf8767b1629750556485b4e88b8786fd0b86594a34aaac0026c66f8d0223291"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0dc33dda333c84d8b267b022b4c3c3bb0473fd381fb25337d3618d632582e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75dd3bd12e669bda2f10a9374d38d41dc2064271ea01b3d3cbc357f869938f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2b0015ec92c6f444cd070d30c1415b84e1f2ab6d12e0c3982aa37969ae30eb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
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
    tags = %w[json1 sqleanall]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
