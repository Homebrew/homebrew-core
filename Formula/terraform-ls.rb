class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.19.1.tar.gz"
  sha256 "d12cbce7ba286c020a5474c03249c49a7b31098a8b9e8f2ec710937002174b31"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef3556ebf7c89830ba18ade35f0d762d5dd6e2f75bd236c1fee46a66a4bb50b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0e0c5655900237954741cf40dd1919a873f0035d3edd1070bce608ee313f346"
    sha256 cellar: :any_skip_relocation, catalina:      "133efcb8d0b56c65fe2b272291b516b7aed51dd60c75bbfe8fcf85082daab113"
    sha256 cellar: :any_skip_relocation, mojave:        "e6734eaeb00ad3c7cbdc1160b40966e2322df1bff866683ea9099cae1b91c2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9063b9517fbd3c3e8ee13bad6c4d25eab7883dcd447a42359633fb85da9d9e8a"
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
