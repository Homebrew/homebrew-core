class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "31f755d3d465842cb53be2b53cb46c93263cde0d0e0fbf0eafb0e39622bcb393"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a660543311e14fb5db99b2f214f1b0972bb105f1f85bfe53e115462cd81861c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9cac7b033e98c0a52cea398b6d5655e2ef7b36c8b7f1e632304ef5bab211d25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad80fa120c2aab9acd9dde8c8a27d51baee445bce077d4f8ad19c1583cb66ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "31169fa4c68908d26193744bb2918ae49247a80dab8f9c03fda68ca328ea390c"
    sha256 cellar: :any_skip_relocation, monterey:       "21372945af269e039f3d8b4bd7a8f142849e581fb4d93f855cc0a286ecee89ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc4047b5a1372af2a16ad83c65e646181017e09b6b767e7bee07d43424e2375e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e0a1ba81762d21c326d42c3392266ab4c32fc743a78eb304c1eb0977ce20e1"
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
