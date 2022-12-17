class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d2269af0fc93ebf9d691bc7d25262aeb43ea01309290c90c0996ed2b9392b8e2"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e38037376fbf03f62a72b806720dcd08bc4fa2652ede30f71b961ab3d7e466b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddf28c6e4f542a436d64209f6aa24f1ce8dabace6ebc37fbd9dd6893d35b1799"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd6505e7ef141b929d17da8eafee396f3e3cfcf2a645ca83623dc260fb897a05"
    sha256 cellar: :any_skip_relocation, ventura:        "3c56e1a28860b18ac78ec0c1cc1c1662c8de8282f24dfddb731298a6ef6abac8"
    sha256 cellar: :any_skip_relocation, monterey:       "c7b01635e75e1f26b2fdea9fa20ef317c1994e52620a7c2e9c42adbfc3c8a0d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24a330eaabacf87a95bced13a24785e6984cf3106737895e00c22c9f3d84e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a6ec84b8c99423a4fe6a5bcb9607c4e72f51c5f5935238a38d0c5593b38f0ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"
    port = free_port

    # proxy localhost:80 with delay of 100ms
    r, _, pid = PTY.spawn("#{bin}/tproxy -p #{port} -r localhost:80 -d 100ms")
    assert_match "Listening on 127.0.0.1:#{port}", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
