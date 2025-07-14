class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.8.175.tar.gz"
  sha256 "5b9c151be27362610ec6e7bd635a62ef07a1fa3ff1824771492528d6a320fb92"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2afe79c273b9e7eaa69374aa0e38a2abe7fb6af36b3ebcad4987ed9603e47898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d1ee072affd91d1f4de2bb70fecec70ebd54b4ebc826d99b8080d206a98e785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1afbfef32b10c60463044617e10edd650538a28b6e8ab64f8bdeec18feec9e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc26b08290d072d0bc476bb23bbbea17976c90f421b1c091530588836645829"
    sha256 cellar: :any_skip_relocation, ventura:       "2ece9adfbfc049196ee14b4f656e8442dad89ad76f28061dc9f74ac87cea976b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c102fae809361d2843767e216bb234a1be57800f5e32c4f6e82dcedc9516013a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1348377ab4a7dfa9c11b116388949e82b5106532ddb171362eb2c726580783cf"
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
