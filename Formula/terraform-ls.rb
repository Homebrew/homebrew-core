class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.25.2.tar.gz"
  sha256 "ec028b03bb80a220e6ebed17c470ac6319839f53c6ad0a83b0e060e08a197ac1"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9382dc0c399ac95d909acf2408c9fd764b3b9a1b38f6348a0441e167e250189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ef340a3186ebe7e3e5cadae17d560aac77350a5e059e6fc21c2c726555fe24e"
    sha256 cellar: :any_skip_relocation, monterey:       "84cec27e80cabfa82fc6f3d14beed3ecba098c0e7a8320f599277b1a91aa386b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d62f528df7445c813eb5dbc9a9d833ff346adfcce28535bbd271ebb8ac37eb4"
    sha256 cellar: :any_skip_relocation, catalina:       "8566af2f89e1cc12fe97b41115aeb568925c5965e9f5c61c2bcbb7d51a11d155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba40c401a9db1df6a9abeca13a2b84824df366659041957347a20f4ede3a078"
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
