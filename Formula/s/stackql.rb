class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.8.141.tar.gz"
  sha256 "2768bcba103d3888cd945e832f9ea3e643083ce6ef431b1476c36c8bd93638a4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f20d3499018714af92dcb06817f966c272e6d7549ed18d7ce21b9d81df6058d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16da6a7457903e6d3384182393efc640f81a9cb9c8fb525de465dc7ef236093f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cff72633cf85c45c3298a0c46e9aa056018f25e87b0ae5c41a1004917385f0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a874879a5d3dd75f14b9d03c6ad41c81ab57ba8d3bcc16116e16feb37b5b69"
    sha256 cellar: :any_skip_relocation, ventura:       "250aa91e941ab78b9bef5a0f1935b6cf9f69da920b62845da4dd1c2f88dec3b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82724933879f0382a7df9dc17a6eff3a7adc246b97b854a745ee326a91ae6f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0bfaa915ff87e5d3f337f7394136398e706eb7b14c019dc99357546f3ccf633"
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
    tags = %w[
      json1
      sqleanall
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
