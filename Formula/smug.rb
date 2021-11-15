class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "314711f616ea71613fe883fe579e7d3bc0051f540f27c7925a1ce6a0ece69378"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    system "make", "test"
  end

  test do
    system "smug"
  end
end
