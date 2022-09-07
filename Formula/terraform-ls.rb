class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.29.2.tar.gz"
  sha256 "95a21bb7f0a5df7adb7ca94cb4e0e8db0a318b4d39102ff8e79199c188a33823"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deadaf52508bd7af335cc3e23e0b661d2ada0326a6a5dba513a1a07ad896fb38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6730923a5f4449b2052c2af98d952bb9257b7cb43ad4d904fa076755eb2b390"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e28b107c4968222f09ff0f11b2e09397d86a92537a8936a512edb041b61623"
    sha256 cellar: :any_skip_relocation, big_sur:        "09cce462519a761d0d638a85d56d12cfe8b54850b630e9342fa1a3248074322a"
    sha256 cellar: :any_skip_relocation, catalina:       "f372f27a38e2b2840a5e4debb182b46b4d8a37f0756a62dee7616a71cf6b215f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7319f1c62804c33eca6bf46e6d34716806d61d8b2d13fbe78afc8f75d0c9cb7b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.versionPrerelease=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
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
