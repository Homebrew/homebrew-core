class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.6.1.tar.gz"
  sha256 "9a9f10995484ad12f09d79654181f437b1a8ce17be75dbdf799a0b604e6e8375"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "585a5b91ccd9e1ab9238c06cf5f3a49526d8be2df05ebf58df3948afdf9b3c14" => :catalina
    sha256 "913dba8ec8eeb9db4933520083ab1b27c49f332dc48744b089c52d2a89960c7e" => :mojave
    sha256 "87b86cbf117c4aa3cb11be9f4be025171e510127b40bed5d6db91fa3b6f1a7f4" => :high_sierra
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
