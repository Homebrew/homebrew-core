class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.10.tar.gz"
  sha256 "2b7d2b2aedc7084e2d7d4efa104e6e0eb2ab3eb991f693ec9f38cdfb9c95e641"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5480e2917f6c696d1294192025b3e43e9080ff5ab65ba261bc315c6d6768296"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c15330d785fd02054d3840e96b9e4f3e66cc363d12926c9517cbb069bd692605"
    sha256 cellar: :any_skip_relocation, monterey:       "b24c51bf75256c38bc5c53acc6fb937fdce1ff255d170a94b8eac56d661e2ca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8532c435ee59f15be84341afabba9aab5c4bbdf752e712b99dacaa485b1a4c43"
    sha256 cellar: :any_skip_relocation, catalina:       "a8b68351c762af758ea6c9794242a1ad1c8dc9b4a78c6c53fc4c5e5b549318e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906c27d249dae1de77217b51113826d5cf12f1c301a567105bfea96df9ddb5eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
