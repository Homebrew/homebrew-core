class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "9db71f05284d37eda9dfb5b97f8e5bc9dbc01d5aebe9553e2f5c8dd6ffbcf5b9"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2dd8180fd8ac9b339b47e99f7f1218621a2ab0aa079df21580b22893ad275bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2dd8180fd8ac9b339b47e99f7f1218621a2ab0aa079df21580b22893ad275bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2dd8180fd8ac9b339b47e99f7f1218621a2ab0aa079df21580b22893ad275bf"
    sha256 cellar: :any_skip_relocation, ventura:        "cea04a0c3207f8b7bfee4105fb93be44e9785a8098198afd85d75023ea942a19"
    sha256 cellar: :any_skip_relocation, monterey:       "cea04a0c3207f8b7bfee4105fb93be44e9785a8098198afd85d75023ea942a19"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea04a0c3207f8b7bfee4105fb93be44e9785a8098198afd85d75023ea942a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ab374c94fc052b0bc17ca94629401ee634db9936303fe64e6dc8c4b28e8c61"
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
