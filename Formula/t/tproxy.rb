class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a6de7bc8b98c1db6ced19f8d5c98765d377cf81c3a5db97e7ffaaf153ebae2d5"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dab038b678fa637b05267a3c888dcea29832366b6a69f50439ce3230ffb81ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c09fd3881b07f2abf0c5923323c55e277577c4e409f093bda84ec1c6bb6cbd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade5ef92bc135213d2be4753e2701c2f9015afd93534c9a182f010d3691668fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27669f5b3c1376784ae82d28f1841308eb98e5d4af5fa8d00db822cafc53b2b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b06315ff32faabc77582ffc9080cbb08de6a05c0b8a3352072e32334ef032a2a"
    sha256 cellar: :any_skip_relocation, ventura:        "660ae0f7a7097370a031c844360f59639ee27e290e7ab31046b819d4a7fa3689"
    sha256 cellar: :any_skip_relocation, monterey:       "493a868529ba3fb492f3932fc4f439544294bdad1db8a4a86b34cf482a805897"
    sha256 cellar: :any_skip_relocation, big_sur:        "57e4a34632dc1788453ef9761e1b13639ce82d9cdd084e9e7db64dfaf244d39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b98d8a8087647bf916bed6f92a500ed693697dba8c08c80d349fd901f94646a"
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
