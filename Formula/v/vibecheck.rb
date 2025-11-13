class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2c299bc1d1223220332c51cc1981324cef63889321eaa2c8a4644e9451232879"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/vibecheck"
  end

  test do
    system "#{bin}/vibecheck", "--version"
  end
end
