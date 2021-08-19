class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.6.tar.gz"
  sha256 "2721bb1cf8f1f6d3bf9d9d4cb6c289047f3180b3fa8eeda5272a36343992d5ca"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48eda9bda51cad2c18a6e344acc04bd426146ae017076ab750b0f50bad0e4efa"
    sha256 cellar: :any_skip_relocation, big_sur:       "811ef23bfdc97ee82729d35dffa5a40e8e96ae0646d03ce4a0a1f49add45b502"
    sha256 cellar: :any_skip_relocation, catalina:      "4e26badb10d7a26372983909f868595787ce64d4da49a97c8729934fd2d2bc92"
    sha256 cellar: :any_skip_relocation, mojave:        "56e59da72fd6403cda4404c3791160269369d5df5e1ccdfda6a7ab5dd0ba0c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1327d98581cfe3d23c3909924c109f7f8c4bc6dab6debbc229103283e1842c98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
