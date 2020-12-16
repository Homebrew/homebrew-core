class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.11.0.tar.gz"
  sha256 "1cdbc77a4f6c91183f54b7d9d2a2ae36f9561d313edfd2ab35b33310fd42a852"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f16bd864634135cdf9db9db07cbbb24ef1f1a7165707b4aed736b97376998d6" => :big_sur
    sha256 "49be1f2b0720b75a357f62294a1435d9911153752791bf187220be7d35b41f4b" => :catalina
    sha256 "e929d98b6ec3f7ded0f52a4509591a91dd4a61f7d2419432540e5254443e6e8b" => :mojave
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
