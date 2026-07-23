class SwgpGo < Formula
  desc "Simple WireGuard proxy with minimal overhead for WireGuard traffic"
  homepage "https://github.com/database64128/swgp-go"
  url "https://github.com/database64128/swgp-go/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0d7e5ebce9c07237e71028eac31b27c51d155c5a72eefc7bceac4cc816725d23"
  license "AGPL-3.0-or-later"
  head "https://github.com/database64128/swgp-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdfae695127feaa5e26ec03dcbde71f75803c2dab1e4d8c0c297a80dea58ce31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdfae695127feaa5e26ec03dcbde71f75803c2dab1e4d8c0c297a80dea58ce31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdfae695127feaa5e26ec03dcbde71f75803c2dab1e4d8c0c297a80dea58ce31"
    sha256 cellar: :any_skip_relocation, sonoma:        "64fd20ba71db36ab9bf5e3577c797449b8f9c2111f5fd4e5978b6c0911a6b50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84055bdae48f8444c94d3a63b8c6a0b37487aec3bf0148e8a1eac40c8c590608"
    sha256 cellar: :any,                 x86_64_linux:  "1e176152d4b820a2aaa2c08e565fea40d8d9050f4fa7a661e3882912a3412f2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/swgp-go"
  end

  test do
    wg_server_port = free_port
    wg_client_port = free_port
    listen_port = free_port
    (testpath/"server.json").write <<~JSON
      {
        "servers": [
          {
            "name": "server",
            "proxyListen": ":#{listen_port}",
            "proxyMode": "zero-overhead-2026",
            "proxyPSK": "sAe5RvzLJ3Q0Ll88QRM1N01dYk83Q4y0rXMP1i4rDmI=",
            "proxyFwmark": 0,
            "wgEndpoint": "[::1]:#{wg_server_port}",
            "wgFwmark": 0,
            "mtu": 1500
          }
        ]
      }
    JSON
    server = spawn bin/"swgp-go", "-confPath", testpath/"server.json"

    (testpath/"client.json").write <<~JSON
      {
        "clients": [
          {
            "name": "client",
            "wgListen": ":#{wg_client_port}",
            "wgFwmark": 0,
            "proxyEndpoint": "[::1]:#{listen_port}",
            "proxyMode": "zero-overhead-2026",
            "proxyPSK": "sAe5RvzLJ3Q0Ll88QRM1N01dYk83Q4y0rXMP1i4rDmI=",
            "proxyFwmark": 0,
            "mtu": 1500
          }
        ]
      }
    JSON
    client = spawn bin/"swgp-go", "-confPath", testpath/"client.json"

    sleep 3
  ensure
    Process.kill "TERM", server
    Process.kill "TERM", client
    Process.wait server
    Process.wait client
  end
end
