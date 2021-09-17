class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.22.0.tar.gz"
  sha256 "9915e8384b9b1219b6ac5816ad377b23a7aabd8164159e42f7bf01d8fa93924b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d590b4a8f4ff9d59f897fc269855e27500f36c6e002188524fbd75007b0220ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "8204464d49785770ac7f7d7c4c67d2e48d70c7067d296daf0e68f683663f9c51"
    sha256 cellar: :any_skip_relocation, catalina:      "a0eb47188827f9e3f5e073400edcf290fc8638b4e50e21d53d82ce782c504639"
    sha256 cellar: :any_skip_relocation, mojave:        "da83ae8cd19ccc8128c701c12cbdea98d2722e7a3106d78ef51bc6a563c2b661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6175a34c2fff74333644a1dd141359040e794011b20bf35e9fbd111e3b55db"
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
