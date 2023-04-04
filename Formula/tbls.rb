class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.64.1.tar.gz"
  sha256 "2fe72ac714320da44ffa2e1f36393733eccb9d1a91f88515624bfe12b5c8ccae"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0685647235f83c8fb3f072e20f800b1ba532df6d67bae1a588299386083a8edf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8275e5b4804f197951bf96d5fcc06310104e2a78003d00c4b0cb2fa3bd4677c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5e12f7d11ccea0eabd8b2d5205e8ce8bb55e51988b80c0cccafab6ddc581e93"
    sha256 cellar: :any_skip_relocation, ventura:        "0bf26b449a48131d87e44142b787833ee2a81e43a66a3ce4046a401b75e80de6"
    sha256 cellar: :any_skip_relocation, monterey:       "677e4907be97cc15be0df0f9bf37380df86e728e4176afcddc65457321dcfe31"
    sha256 cellar: :any_skip_relocation, big_sur:        "68201f261548fb7ec639798b715935b83117e90d91fad5e6266142aeca19796f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25316d7dbd0914590d9c6ba1d0ac7e55eaa2769700a3f5b3aef77c1d50c726ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
