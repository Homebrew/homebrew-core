class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.5.1.tar.gz"
  sha256 "7734a184e5d00d65600fe6c9d9393355473e936bd0a91e51ef8bb3f6cf2d5eef"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac5509eab0c8164a7ac5535694b5b4faccc873124ce58533e0df273736ad388e" => :catalina
    sha256 "41475cfd0f4524cc2f04cf2adb78817961c91df80ae1f619c15ab9dcf4338222" => :mojave
    sha256 "834a09ae4e5aa766b00a65451fa00bee7e93a84e9dfd424f9b2ad5a7cdbed503" => :high_sierra
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
