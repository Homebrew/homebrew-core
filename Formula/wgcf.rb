class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.12.tar.gz"
  sha256 "6945b032b9376f10167c6602f0ae3767f301b9b200c1aa6d543a874d91afbbc0"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8695a30e792e0169f13ee79aa9b706f85ea485d9e21d210c279b15a25304d2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22941234b12636df2c8bbcc568dae7a6d1bc471d9de9c13bfa01bba60f3494d6"
    sha256 cellar: :any_skip_relocation, monterey:       "b650c722a73d4e083325c4cbdaedf6d94c0f7770c85d163bba55d5349e576968"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e692533675cdbb32864e714ae4404c045137204bb9b68c02e4996e251d3bc8e"
    sha256 cellar: :any_skip_relocation, catalina:       "814c739ac8193f1f8cbb0539bb51593bb1c000031f251da42d642b658d13d6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f286d348cea5baf43edaa12b606075de83a3eb9a26e80d14cb896e15340c7e17"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
