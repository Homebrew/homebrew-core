class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.28.1.tar.gz"
  sha256 "0fdb2ca6800849ae97ded291f50342accfa5b9ed2362dbdc77d0dee465df205d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05f6e33abd60f52ba2e64b02994744604c578e32bc2e67b6ec0da6aabd896cd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "831ae305fd250e8ae58b9a6ff3e6ab3d15b87adf1f92f13a03fbaecd28c04500"
    sha256 cellar: :any_skip_relocation, monterey:       "e91a107bd608cc9fa8108b51d89bfeff726e216fb51067e75756e4e580b71e0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "25bf9afbcb3afa0aa121b7ed8a38e33ab5e596aad8fa5644a3b59eb1c97cf0b3"
    sha256 cellar: :any_skip_relocation, catalina:       "bd10d6e6b667b2fa594c80a8737c75223c36bf26d93b904a9b6f2c91a934931e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f88ddbd672bd5e694f726edfecd9e6cd2ebf8e6d3df401b69be1063fcfa86dcf"
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
