class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "c1738407ba6bf69e04454f27e394c965a7d41c1d482a6a676396729f8a466824"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c6241a54401d714589cb890f2e7d0397626700c939369a8f43d837656d3694b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5009e190b0d22ba61aeffab8faafdaa806649e9ff3c068a6f3de2762b705848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4acba3fb05a1ba6dcd74c50c71e468f0b6aa38df798b11682bc13f127754671"
    sha256 cellar: :any_skip_relocation, ventura:        "abda192d7686ee0a0bff1183da54e93f30c305bea9aea9033b3ec4cc9fa3e31e"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcd44d7499a5c57a6c7897bb67d6e12cee6e653bf22ddca63c5857e83846a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0623f4559c1fd51e8f935bdc6863629970b509123af2a7665187529d1e083a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9b99e2265da7f37b57ba9730f8c6d0bf798f6a251d614a7bb945e64ba7a0443"
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
