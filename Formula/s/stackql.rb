class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.605.tar.gz"
  sha256 "1f32717086c6d1291057f0aaa93f4d6c0846dbac4195bffd898e1bf90a23648d"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "456dfd478b556179dedff562e1f1bc29916142185e8a97a41841ad55ccf9b3e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9869a2dff9bd56cb7de6619260d63feb71f6f727ed24dd190ffcd68fd0aad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16f00b4323ca29719d9b515db41fb20846c26c713e919b9c44d6bf6c1145628"
    sha256 cellar: :any_skip_relocation, sonoma:        "15d07cbf4074d90bd2658f8544d67f3198af9a9cf0875d71add1bcaf5058ecfc"
    sha256 cellar: :any,                 arm64_linux:   "8be759c6a2c72046bd9706d522336e2d154f8dd689d96ead3c7794261fb9eff4"
    sha256 cellar: :any,                 x86_64_linux:  "2cceee0dbb29a1867c9bad321302a00dd58502936301f3a57fa12f53a2d1439e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
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
