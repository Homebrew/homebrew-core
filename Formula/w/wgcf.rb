class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.25.tar.gz"
  sha256 "1f994953aa4e9d6718dd7629957db9ee82f766e22975808cded1dcaf722734d8"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b383c6977ca74792c84672bdb3976bdaf31a0edc633d96856326c3bdcf1bfa38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b383c6977ca74792c84672bdb3976bdaf31a0edc633d96856326c3bdcf1bfa38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b383c6977ca74792c84672bdb3976bdaf31a0edc633d96856326c3bdcf1bfa38"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3c1021119382ce1430e4d403b8a6ff31b792b0f275dea883f1a4e27a0ac5a67"
    sha256 cellar: :any_skip_relocation, ventura:       "a3c1021119382ce1430e4d403b8a6ff31b792b0f275dea883f1a4e27a0ac5a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a885819fd0e7a141073bdb9c44e2d010b4321ee8d682e41e13a2bdd329c5fce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system bin/"wgcf", "trace"
  end
end
