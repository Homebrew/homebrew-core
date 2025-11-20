class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0d5b030c03791882ef077336b689e863b2e41d5f16cdaf8210a76770d219ebc9"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d287d969b2cec4853843339cf6ab489ffd9fcda29758f850e81fddac0ed1c0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f712de225051b2d0321080046ad650ae2c5b6b978514b371582780eaf33a1cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f712de225051b2d0321080046ad650ae2c5b6b978514b371582780eaf33a1cb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f712de225051b2d0321080046ad650ae2c5b6b978514b371582780eaf33a1cb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7568f803d5ed42f93f629f5132a3e9bc48deb6f345f600bb43fac27a12f2d78b"
    sha256 cellar: :any_skip_relocation, ventura:       "7568f803d5ed42f93f629f5132a3e9bc48deb6f345f600bb43fac27a12f2d78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d9fdf1c245ec0aba0fd5ccd9724bba77b3c726066b1164f59b7b734d8efd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2753876622eab4735d7d5c380464e18626ba7d22a89c99036aa9030e080402a"
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
