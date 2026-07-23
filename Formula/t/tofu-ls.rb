class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://opentofu.org"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c55400f22a8f3a34eefba87ada87caa4eba79ca3175d2f62ca3cceab35699dd8"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4c9496b36a303f3143b4bd7b19edfa55b60abf222b1d97bb37a0e9266fffdfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c9496b36a303f3143b4bd7b19edfa55b60abf222b1d97bb37a0e9266fffdfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c9496b36a303f3143b4bd7b19edfa55b60abf222b1d97bb37a0e9266fffdfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9771b03ed85ba4da712a0fb39d809379f89b0b745cd5e4c4c15ef5276084639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17656d0f4da742bda20246e08913cf9cbf50f9e282a8895dd0136299d1e65e4b"
    sha256 cellar: :any,                 x86_64_linux:  "e035e953ddfddb1ad251a15fe58ba9bc1f07db6791826cb7d109bea778add27c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"tofu-ls", "serve", "-port", port.to_s, File::NULL
    begin
      sleep 2
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
