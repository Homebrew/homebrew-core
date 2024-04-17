class Tproxy < Formula
  desc "CLI tool to proxy and analyze TCP connections"
  homepage "https://github.com/kevwan/tproxy"
  url "https://github.com/kevwan/tproxy/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "f6d3413605a03cb290dbdd08d50637203c7c84d16517cd34abc7311203f3cc9e"
  license "MIT"
  head "https://github.com/kevwan/tproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb06f411cc40f326f48954e8d94460c263d1f3f7bd85a039ccd3ae561931fc3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68cf3e95c0cd12044d42c914b9abb0ddda44cb291f7619d773e151c1121d7e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79bcfec2219b2dacb014ccb0e8630438399bc61d6a85bcf94ad0361259958f7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb066a9fd07ea71affb5763d25109842bff24c51b734e8a285b16f57b6d09117"
    sha256 cellar: :any_skip_relocation, ventura:        "84338b9a2e65797eee898956f9534d1d3f7690a2f11dd57293a9b5b7b252f06a"
    sha256 cellar: :any_skip_relocation, monterey:       "353712201999660dfb19485fc8694964b94a57041b9957c3b2f7c9aa25345b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f70748e6b276d4a23d074fa908f1a4914a314aff7cb6aee26fc2961f23d68813"
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
