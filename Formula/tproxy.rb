class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5679c273964073e276c743c3b70249c59941b4f5aa0c0d2df5ae3db59c94aa89"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba0ac64ee2b19134b1f98f9bb39b26226d105216a22086b43706ab2af4d71998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba0ac64ee2b19134b1f98f9bb39b26226d105216a22086b43706ab2af4d71998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba0ac64ee2b19134b1f98f9bb39b26226d105216a22086b43706ab2af4d71998"
    sha256 cellar: :any_skip_relocation, ventura:        "87758a9cab820d8020cbcfeb1e189003fa49db40a059bdf7ea493e7a6628ec81"
    sha256 cellar: :any_skip_relocation, monterey:       "87758a9cab820d8020cbcfeb1e189003fa49db40a059bdf7ea493e7a6628ec81"
    sha256 cellar: :any_skip_relocation, big_sur:        "87758a9cab820d8020cbcfeb1e189003fa49db40a059bdf7ea493e7a6628ec81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899fd7021be8985d2d6ff5c14d23568bda0e3adb0759d4ed4c4ebeae738de9a3"
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
