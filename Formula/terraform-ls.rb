class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.11.0.tar.gz"
  sha256 "1cdbc77a4f6c91183f54b7d9d2a2ae36f9561d313edfd2ab35b33310fd42a852"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50e5f4222bc0eec3b4d4653391e8d718c4887839f094f69b6af44c0346a4436f" => :big_sur
    sha256 "b4600189dfd597ab820ba2eb7a872bda6b256024b6fe9702859934b07c5f83cb" => :catalina
    sha256 "401eb172ef828f02947259c9d652cac5989d14534b776a38cd0228db0eddfa47" => :mojave
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
