class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.426.tar.gz"
  sha256 "1144f092b4cbbb78991d0284246bd660c728948b35f298a8ea59581da7ccc790"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "893bbfbbea089ead7086c53bf708312c1b72b5691989d56f4fc10e2a976ad3b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e1c0dce7887ed1504f27b3ee5d0ae46ad11fdc13a44f534c0567b9f0dcbc48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9bb42486d442e71128300995a61e964b42bebf628da81cf1fcee6463deac9f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "532403aef29fa9e478de4e5f3df9c5927aaa838302d34fdc772dc87e7d167ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c3547edde2eec5662185c3bc487c1416742fb897ef33af298eb571c1b6e788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4908a6672657b93dafd966cab4113871282b2c0c7aeb557fac6cbeb0b6f23316"
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
