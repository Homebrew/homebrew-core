class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.23.0.tar.gz"
  sha256 "66b8abd5ae7fbc489af5b29ec70344c66c06f0c419b38e70e7ae03ea4aea4353"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd10b203fdd4d588ca5c76f329e6e355978330b756fe0b8c21c06ebf3289c919"
    sha256 cellar: :any_skip_relocation, big_sur:       "44f5336b26ca42f288abc8b3524180e753d14d667d0483582d3380da7814b0d8"
    sha256 cellar: :any_skip_relocation, catalina:      "061f5118965ca17ea8295b966429c21397a8e825becb8414ca2ed68446bf26b4"
    sha256 cellar: :any_skip_relocation, mojave:        "af4f454eed66d6c42c4e7313d3b320fa4664945fe2d0d4364be4b0bf851e79fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc1df976b00f3bceb2443a872f97670537aaf3f850d10af2f4d1708e1c7a687c"
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
