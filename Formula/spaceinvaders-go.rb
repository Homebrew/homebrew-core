class SpaceinvadersGo < Formula
  desc "Space Invaders in your terminal written in Go"
  homepage "https://github.com/asib/spaceinvaders"
  url "https://github.com/asib/spaceinvaders/archive/v1.2.1.tar.gz"
  sha256 "3fef982b94784d34ac2ae68c1d5dec12e260974907bce83528fe3c4132bed377"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57c34b53c55580602720eda4556939f1faf1a0822e021ae6f90568ab2d204994"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6843984a81fcb723c3b1487a77c44f2a186a8cb17f00b0531bc8c8259afa303c"
    sha256 cellar: :any_skip_relocation, monterey:       "c23c5bfc361fe30fb1407a346a3c215629a2423c2123c3d99609cc7b820333d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0ed01fe110f5d7d681d12883f58962ae5c0ea721b032e8d3ef0adee41956841"
    sha256 cellar: :any_skip_relocation, catalina:       "1c4712409711d84aa1a7ce64214bb620e13660991f2afacd41681278ae0c3ba1"
    sha256 cellar: :any_skip_relocation, mojave:         "596f084c8dad9588158ea9419e8a7ce4e33e8193d18b18e4095a6443b5e2fbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d2e59d2248dd8e1ce86416197eb5109f7c3c51d98b686517ce3d9fde948d572"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "-o", bin/"spaceinvaders"
  end

  test do
    IO.popen("#{bin}/spaceinvaders", "r+") do |pipe|
      pipe.puts "q"
      pipe.close_write
      pipe.close
    end
  end
end
