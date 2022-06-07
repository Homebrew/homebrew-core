class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.28.0.tar.gz"
  sha256 "3c52faab9ef60f246c1f046b5689306ec6265eca6d560833dd797b8ec80b6129"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1cfd7c26473549fc6a0b582f996bbebdcc37d0f28f63cfb66fb4d0c3a3dadf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46def509248c03c2bb1aa61f1d2652620832adfe693fc760ebf2c7812e13bd9e"
    sha256 cellar: :any_skip_relocation, monterey:       "d6be73fcd41220baea3a9956fcfc92e0df43a2f1ed7017652d86678cf35097cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e30f2a230a1c1add0d74e447ee0e40c8e70c371c70c9068a78bb746207622029"
    sha256 cellar: :any_skip_relocation, catalina:       "20441685569dc1885b2becc76e849fe96c290a23a426aaf3005cd57aba13a4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c55cc0984612356afc04a2c3a9065f504b30b67d5a39bcf025b122c9e7daa1"
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
