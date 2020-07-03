class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.4.0.tar.gz"
  sha256 "b0279de3016a19d6e3055c71d482a6e22856aa8cf2a70153bb8d5c335edf88ce"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "416c8c63f9303f58917c1363fa6aef7aa2910237c3b4d704abb56bc833105549" => :catalina
    sha256 "ea6b00466b0a4897aa4d57a6004c9e0977ca394ed0128588c242c4bd788a0d7e" => :mojave
    sha256 "6c10a3e4de7d6d2bc03406085f9588ece1baa6f871dfb10d69d28d5dec7c0175" => :high_sierra
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
