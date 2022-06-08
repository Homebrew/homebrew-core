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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddf5b3c3bc2f26278590023c13c116d88675c419b27f8cc68d51f3e01b395900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22dccd5f4fb03f4662e86a4dfd78a8f6533e7caf370d2e89ad3dbdc7c78a591"
    sha256 cellar: :any_skip_relocation, monterey:       "2ccf2cdf09b717c7a8a6525626e4dbb17b3a7d49846e26e257598495eb486215"
    sha256 cellar: :any_skip_relocation, big_sur:        "f16d05b4c28467cee536bc600e1e785b8197accc1a4e004d1c7103a28a45d229"
    sha256 cellar: :any_skip_relocation, catalina:       "f0d2102d2dec7b4917c236849edd7b2941a13e48bf534728ac0f4daf1113ca1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53cb15672bd6a03392b2a16ac65295087de7591cd63e01e0eea8e4ffae385b4d"
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
