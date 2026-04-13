class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.421.tar.gz"
  sha256 "184c4ff835f2f0771b8a804de5555c1e894ed0f8e0e47a9455b7fcc48a3c415b"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9712ae3c126e1f0b5b6772f6e21ed77c68fb0470148d7ffbf340c920d18ecda3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ab526e2cbf858560a648b2216d7fe831037b4728b76702ba08e3699f821f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5f47b2298c9ffd5b864d62d3ad49a0cdb3e0a0d8175140c1d1d4b35c07a379"
    sha256 cellar: :any_skip_relocation, sonoma:        "4889592f5c0e50509c11984ecc82ca01a02a7e5ce5bb024b0e5362cc0d0be191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "186641e2d483a1448cb11131a3aba71d59a37abf0c6a0d9921844fb404596cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93ae0e9c666bff37131d99912098149e670446ad5fd5fb738f1e00af4ebb7a6"
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
