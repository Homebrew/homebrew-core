class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.26.0.tar.gz"
  sha256 "e4d67e3faee34a4555fcd8e68aa0a18a5df8669edc0e2a4d3c04acbf80d2d5c3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b42ac619f103f811371059947f61a89398a5a910a45844c5f5bca7f76edead99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a079276b22f758c55d059e7c47b72f9154efc6d0d4910b6a8f9544314ceaca01"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb8725a74035a8302403a3a3e0ca92d1a3a6c3e9cf0992dd7752038b583f720"
    sha256 cellar: :any_skip_relocation, big_sur:        "276ba8bfbd91dd94d68f6705ddb50ec867e653c9a36cd1ab5c4a41e4578da3c1"
    sha256 cellar: :any_skip_relocation, catalina:       "6f23360edfea9f98b15573db8da29c1b1c67c7d25fefb52e43f0eaa0bfad856a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e802f5f466bb2935a7e08f2ead60ec6a240fbc5c32c1db3b4986c1469202e4"
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
