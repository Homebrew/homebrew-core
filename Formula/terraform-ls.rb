class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.19.0.tar.gz"
  sha256 "ee9cb93fb849c8998b53b7de24b5c0de31acf656e0bc678b6f70adf2f6978df8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0245198d41c2737d80c2aa3520f5b20108582b7f44aec17bdc38db8c9cfd90d"
    sha256 cellar: :any_skip_relocation, big_sur:       "494995c67759d4510ff9dcd8cca54c5d0dc1514dbd1f6d583774d1aade9f8604"
    sha256 cellar: :any_skip_relocation, catalina:      "48c333c9b410a1419b6454538009218001721ecf58ca3187ab09ffec70527201"
    sha256 cellar: :any_skip_relocation, mojave:        "155faa95cdb3628cc9f30fad42146bb25894b78449d9069056c552746d34a61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5527b092843f7c67d209382edd32c75673286a2a207bf8947b045102484ec374"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
