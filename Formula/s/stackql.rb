class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.542.tar.gz"
  sha256 "ce3c15b1931b69d20682037d21bb7c2043eb100f66f28799d0af7dfc0891ec81"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e5d24fca886029f0fc1bd2a814092a3cdb7e1a0f337de2d4b38ebf4585dafd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f49fb0ed4ea779f857b35ef727185d181439a7808ba1347e03e5f45c84f729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac2a90b415c9bbe8cb49f2f703898d240d17a3ecad14a00590c33391263f6cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d907c77a0e1e06c7b0e403edc177af6c65a828692a0be0b4c1b1499206306f"
    sha256 cellar: :any,                 arm64_linux:   "3da179542846a041825ad6cca6da3b1c85fed72ac72df372cfb8b625a83815a8"
    sha256 cellar: :any,                 x86_64_linux:  "e45c1f8b0ef138f998a69536aec13f64bc44a3d83d5f97c35724ecec10c298fb"
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
