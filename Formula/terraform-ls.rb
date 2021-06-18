class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.18.1.tar.gz"
  sha256 "d3f198ce29f22c1629165287d9b6596a8d77c402c870d281a33ffefada1620ac"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af96fa296a11276a2b236a5bb3908c17d59547deaf66288c17ae17acf8168cfc"
    sha256 cellar: :any_skip_relocation, big_sur:       "a661cd44d22b05b3adba80a6413524bd80882e72ff595a87dfd4525f3f491a4e"
    sha256 cellar: :any_skip_relocation, catalina:      "81640ca452d7f880ac71267a021930a3f7e35d007844e007cd65f3e11c406183"
    sha256 cellar: :any_skip_relocation, mojave:        "ab91956b84b90bc3b3cb95df43e6e79399e1c8488979231cef4c83cca9243111"
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
