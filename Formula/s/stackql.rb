class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.6.50.tar.gz"
  sha256 "d64a1ef7b154346a4b3bda1ebdcb0d90d3f441a9b47fdf43ec9e18083aadcf47"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae9d5cd9f000d8989ceb57f31f41c83dbb1ac58dfcc54681dac8235025732387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04b4868680eda95d3717d8091ffc2af6425bd25c88622a048073813870bd1a4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54e2e925428596016694c0880df39e6e72b16205f768899f0eece53630f356b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "61a86b78f67d378e21b3caa1cba85b9ef22b5624bb3dcdf02b9057eab6b4c0f2"
    sha256 cellar: :any_skip_relocation, ventura:       "c361a3d437d5f32ccfd2253a7f85dbf91439125897e22f1859a13527cbb662f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144dff02c7094494a287f020c9f30a785c5cf6250cdfcc302af328278ad64a0c"
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
