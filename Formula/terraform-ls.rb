class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.9.0.tar.gz"
  sha256 "df01dcec0f97f6fbc8ec35368b837d3c670a799cc4feb1c20056041b20c6cd1a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "530b78ef9e645e3f0f7fcac54c3b601895d7a479c92d3ec4b0cb4034611b2a06" => :catalina
    sha256 "4e16cdeb57ea4714e6d6b0bd9c761176d44aa2a9b1ed3de293f059ea4ed17643" => :mojave
    sha256 "ee065f61f18a909cdfa9cabf723d8fdc4c83942950a64a792aa081c245731cbc" => :high_sierra
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
