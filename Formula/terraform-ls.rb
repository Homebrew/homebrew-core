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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5be23afe8425ccdcd262593b59085512963e7fd06e0f739faa7e7cc16753193"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e68078bde41c141cc5895ca757479990a20f534cdd71a38efce7517f937cfd9"
    sha256 cellar: :any_skip_relocation, catalina:      "9dc2ed2078a9071912a2cec9cc57e32b19d69ef6a464a1332dfd179053ecef50"
    sha256 cellar: :any_skip_relocation, mojave:        "c8240fdb588ec573c301f86fdd8245568075280e3c4b2d321d4830ebc6758303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197d1940c2f4bd851c1a6b2d81b26719a0e26a7468d4d3750b205ef56fe9aa53"
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
