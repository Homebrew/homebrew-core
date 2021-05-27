class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.17.1.tar.gz"
  sha256 "143b2eff3dfd108fbdaf451a360425e5b8bcd9500c4276d00b76ab508085b01b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "87ed4c34b3383f115dcc1a80c703f8374701a9bbb8d245a5d47899141889a011"
    sha256 cellar: :any_skip_relocation, big_sur:       "f46e00270046bcdf92ab45a2e55c4b462aa2276ec26b7bfe4cc364214c4c4b80"
    sha256 cellar: :any_skip_relocation, catalina:      "52383c93da9ed85a0029d636fa0d07d059a34fa62dd4121f426d8ed4eac95496"
    sha256 cellar: :any_skip_relocation, mojave:        "5e977759013047eed576a9bbda4ce678ee536bbfc8c348df017fd5134dcdaa4f"
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
