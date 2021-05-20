class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.17.0.tar.gz"
  sha256 "f1fc4466de505a80a697d06200fd930c094d710de1c65e551785e1af8cdf8a2a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4fead0b05fa379a27116a031ae5af2a910c6974b9bb757eed9407d04d99d3bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "0587efaef10898b2e23cd4769fb50ac4151198fef2fe4889fe4779bf174f18e6"
    sha256 cellar: :any_skip_relocation, catalina:      "af34e3ad46ae6184dde7c1434593b7438e1ee54891085063a66e02f06c0c778b"
    sha256 cellar: :any_skip_relocation, mojave:        "aa16538d4e07c3b18647f7b8438cf6bb2ecd5a3cbd55a0143144d37a7da42601"
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
