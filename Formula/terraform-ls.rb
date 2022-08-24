class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.29.1.tar.gz"
  sha256 "58de088f29485fb3cd8ba23f93d06dbc183737630731e35c260a5c03931bf980"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872e636cd2a44a0d675480870f303c6624b1a93bdf577947f4cdab808ffd4b6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2316231bb5f6c2f6cdd065bdf9e2defcf8e5786b24f1872047b806ac3f860111"
    sha256 cellar: :any_skip_relocation, monterey:       "2d921ebeddedfdf0344ae0028a11fca306985460759d6669384d206e2bd1a0ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "70305a59e973f143dcb2a327db18bd6a0eaf00356bf530747454a9ea41946642"
    sha256 cellar: :any_skip_relocation, catalina:       "dc8262748c36a35a10671cfd35f7d601e62464935c3fcec05b87ff011432c794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f27616cdb4bea01a2d067529c5760dfdc6fedffdc395a6ab6a47413e098add"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.versionPrerelease=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
