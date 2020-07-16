class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.5.2.tar.gz"
  sha256 "33d8b5e8d1282e6b6207d0dc3fe3f038230c78dcb83fc1773ac424bebbae25f5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b3db33fca84711453f494ba805fb640779ada4f45bcea6400adb069106c190" => :catalina
    sha256 "65af6093a70058f9a0eaca3ca12c536ffdcf0448d4c835621c0de6c250f40234" => :mojave
    sha256 "6c6fa5bf6f2827e0bac8bff84fdb649a8fb34d726cc5e1a264c372f27ae3c7dc" => :high_sierra
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
