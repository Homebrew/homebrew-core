class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "5376816b6f5d7765b401f74d3feb78fbf307cb6b725627b2e953ff9d02e8dc53"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab25a051fc746628c60b3112afe09dd6acd27da5e6abdba9c899bcf726bea0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab25a051fc746628c60b3112afe09dd6acd27da5e6abdba9c899bcf726bea0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab25a051fc746628c60b3112afe09dd6acd27da5e6abdba9c899bcf726bea0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14fc2adcdc0bc52e12e3a3a76abd49b182ff8a71efe1e87bb8cd632cfc6096a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1ba9e470cf6a647f83c94cb2a4d34c27d2463d2e94993a248b3a2cd3f57537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2b5079962182fcbf0d691a8f57d5271a9a6daacf256b88e984b42938cbcc33"
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
