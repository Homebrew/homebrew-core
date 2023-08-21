class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "b6b226525365f3ae510e34be9cb23831a61474959235c308b5cd9fc546aecda2"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "015bc38f0bd8c525a46a51d13a259cef1e26644ed95a7d515749d0a877dfb3d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "015bc38f0bd8c525a46a51d13a259cef1e26644ed95a7d515749d0a877dfb3d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "015bc38f0bd8c525a46a51d13a259cef1e26644ed95a7d515749d0a877dfb3d0"
    sha256 cellar: :any_skip_relocation, ventura:        "f6dca47ef57efa2caec4f07d1cfa9028bdbd2b158bd7693f4ec6b47f39ac925d"
    sha256 cellar: :any_skip_relocation, monterey:       "f6dca47ef57efa2caec4f07d1cfa9028bdbd2b158bd7693f4ec6b47f39ac925d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6dca47ef57efa2caec4f07d1cfa9028bdbd2b158bd7693f4ec6b47f39ac925d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f184fbc30d9a748c4671d1d21876ccc7503d54bac57b19aa1f1bcd14239f71"
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
