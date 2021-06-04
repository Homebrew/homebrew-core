class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.17.1.tar.gz"
  sha256 "143b2eff3dfd108fbdaf451a360425e5b8bcd9500c4276d00b76ab508085b01b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdbf2ef61c88d1c43d58bd480cf2e6d9c64b74ed33b128351a8d2cb124f27ab0"
    sha256 cellar: :any_skip_relocation, big_sur:       "71fee8758db4077ec7227b1ed1f7df729d0fb920b4df9afb1fa27459b4dc2bbe"
    sha256 cellar: :any_skip_relocation, catalina:      "c290d00be4e71aed9b87c5a884b5a7990641e3f79dad4f10b968cce22454f099"
    sha256 cellar: :any_skip_relocation, mojave:        "e69bee59c9a3d0591def18194dacd363a88d564d9bf07aaa877b19139725aea1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
