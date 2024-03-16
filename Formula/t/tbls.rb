class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.73.3.tar.gz"
  sha256 "4802033aada3401130c834042dd372ae9005ab3bc0b5b1e6bae365e0efc94332"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "126788304830cdde290c5175c863d1a03948ca0fa3945c03c1e4c77b86a95d03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faef222b78200d6d1d94d7533dd4a16d3d01c80393c87586e110750a381c5bd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e759d33825cd27fdef92ce8c94dae15580c9d163accf4aa2fbbfbd77a0d99a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bedaec353828ae6f504ff19abf8292d9a1e1cf1c14f0832c811ed7f90d6afbe"
    sha256 cellar: :any_skip_relocation, ventura:        "55e1a683ca92b2e3f026b3785f8010c2d4392d68eade9b20943f927ef239fee0"
    sha256 cellar: :any_skip_relocation, monterey:       "acd7db2222633f4377c384b35bad79e0b02ef337a0247c40ae9622d3a1fc71b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2941473b92fc029e56514adeefd332227b4d3ab0040ceaecb9ee19a0eeab4b07"
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

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
