class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.94.5.tar.gz"
  sha256 "cde6bbfd49ebf005a9bd85ae213e83adce2d3876966754f6c63f9ffc4583c951"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a07adbaaba889f52a54eb705560e8db06a0f3c71d6ada44b5d35a13a34e70b42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "175ba72715d21982b02cb3fafdbad69cec479c4c5520c33e2a15323f61b62d49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec87420e23d023a6bd9dd758587d6db5112e569a0ddfb0a7645cb62817f06546"
    sha256 cellar: :any_skip_relocation, sonoma:        "51bb9d3ecec4bf3e1ef5afd40bd9f6377a69db2fe8d66812b76a60ed942bf01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca9896865c6ddccf04db99a3b473fcde589c3ad0e4f7ace6fdf2f08c39e59f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768b2807330c47ae8b0f9464186ff87c9626d7bb14c9387b793cbd6a43633459"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
