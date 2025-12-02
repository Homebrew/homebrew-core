class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "90690631690a778072d51d5f41df60b4fe56dd99b2cfb8f6041b17d469b42b73"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e523854726baf5de5f2dda283c9180bef7b062d6b5fa1bb1fb0eeff810dde885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e523854726baf5de5f2dda283c9180bef7b062d6b5fa1bb1fb0eeff810dde885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e523854726baf5de5f2dda283c9180bef7b062d6b5fa1bb1fb0eeff810dde885"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad15923b80bb808be6213658b8bbc97e8d366da245ad59427a1da03f41e5fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2cbbffb6f105440168c071a848aac4e5fdb5a40942ffb4ac77d98e1937c5d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63536e9b01655abbfa636ce2a0c92bd969192e299ea7eba4089c5e6b36f2abe3"
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

    pid = fork do
      exec "#{bin}/tofu-ls serve -port #{port} /dev/null"
    end
    sleep 2

    begin
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
