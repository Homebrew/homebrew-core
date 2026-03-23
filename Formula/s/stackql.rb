class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.383.tar.gz"
  sha256 "e74fa37e9373fe21b5d9716b5402c105a73c29fd6ef70337e43257ee3b280b7d"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af77092e4e0fe796b3bea565a31c6bd9b4f0d8a9ec13341be36377f01ae95a25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2e22b8b601411c0f201209c349f1c4c16c71c7e845d81250eda943fe214f4d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c2f1fb933b4a7fa646dad260a99dfb6c96c737f8aa26c21bed3832135ddbdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c1f5a6bc080bc74c519d132dea9b804af1a74e10eb7c25b6ff7e31757892a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d17697336f404fe5ee3e101f771bde85937e6dc3055eea67e198950be8d11e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33dddee3b043295f0e20dc9d763426ec14ebdac79f5d115be0ec42c79142ea3e"
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
