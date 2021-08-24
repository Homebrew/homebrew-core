class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.8.tar.gz"
  sha256 "1e151d8d79b3cd9f3c245ade69282a2e9eeb4414837b99de1b845b21e9952bf5"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f8237910482bafc69e8278381cf25d7ad262dabe3006f9ab49ae23c457e7d06c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6db9085289c734a59fc09273735be1acf1afc939f8f6a91f63ac5eab712bcaf3"
    sha256 cellar: :any_skip_relocation, catalina:      "9b1a94ac81ee0f7f4984ba67989ad8fce1dea551a88935b7f1dd0bfc9be8a167"
    sha256 cellar: :any_skip_relocation, mojave:        "fd3efd0bedd20e7dd8599913c6b259d99322b139cbeda88a4157a9fde1677b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c408611bfc1a31759ca9ec3746bce7a74060149737116f088090f35857d4c5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
