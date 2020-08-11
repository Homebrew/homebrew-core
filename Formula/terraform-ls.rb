class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.6.0.tar.gz"
  sha256 "cdc6402ed5445d81d693e0d88cc67eef5424c6eba9d07f1a6e7c212b50d780c9"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f29b57df5937d678e6343e1c9ad81aa622d95042733b57a5ef4d2d112a8f8909" => :catalina
    sha256 "8fc835e416e132f45700736981f4893240ffd3305fe92f7d5a7221ab1729d844" => :mojave
    sha256 "2071acac6df267eb2cd11e7c5fb414ee8d3c234cba1595ab5234062cc469b7bd" => :high_sierra
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
