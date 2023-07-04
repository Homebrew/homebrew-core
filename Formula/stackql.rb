class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.396",
      revision: "b7c22ceff5a3a90f04ec3481dd2c52847d152d4e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fed973399d05cd9a37043ec3528560781edb330ce505a4f16bd25786ee0ca0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5608f557de2433064169f2c4c77bd9005676cad6539297be1a1ce5032699a48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5b02952e98f69c9bba8993c45474ab7995f3d827145d1b94be584e7f11e9693"
    sha256 cellar: :any_skip_relocation, ventura:        "94c929ebbc96f01f9ac0843578f22dc83e90723bb72af6a36c857c4d922dedbb"
    sha256 cellar: :any_skip_relocation, monterey:       "73356fbfd6e7c89b7ac798229fa7c4a843a8f2ee950fb513a64f9d9201df3f42"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a209745f3482e8c698bd8ef8d15974c4604fcfba9182be0b66852b6c16bf37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b6f628703bfb6f7b6f3f2f195caa965842cd62e5d3d5e07e3c14720690ae5f3"
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
