class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.20.1.tar.gz"
  sha256 "3ae60b81090d2b32e83ebc7f9a5475197db4dfd7fd22b26708b009fab23a599f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85c965b04bdc1aea1ff29c1e9576e9f01144121def8f613cb95cb1b8b565fff4"
    sha256 cellar: :any_skip_relocation, big_sur:       "5cb4f20ce29e38ae9560c0a55e55b9f0051f0e34095debde6ea0ff79c6acfbc4"
    sha256 cellar: :any_skip_relocation, catalina:      "3f9bdce9ffab6a14f779c4c5667d2ccbee96b0195bc2073261461f7fb0c68a5a"
    sha256 cellar: :any_skip_relocation, mojave:        "cb448efc48b4f87bc0ef1a5618b6ae1682121a9a1884b199eaee7e5bd9c3764f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be94cf20fa53165b8c4d4de8bc8a5e24c9abeb82f703b89963d22a85bf897d74"
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
