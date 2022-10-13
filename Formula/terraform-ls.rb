class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.29.3.tar.gz"
  sha256 "20270431728cc4607a7a351139e6dd1db1cba22798a5ca298dcd0c8b7184c046"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e3fb1e39522b407161ac5f79da5c0ec186eaf658a736b1d57708d520765b4be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63198f8117af9caba2d75e09961680a49b4ff09b09685d6757cc6fdedd069214"
    sha256 cellar: :any_skip_relocation, monterey:       "fbd54302b4972b4be24a34ae341c91f62c8ff4080e49cc069fdf7a3e0443adcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "786e323cb7eb606e92fe8f4886e1991cd7a9cfafdb66ad5b752b1cc930801252"
    sha256 cellar: :any_skip_relocation, catalina:       "e35f506cd0d3b264050748f754e2ec180b8a086439d5b16a1e602277c8587c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8cd3d9e597956330fdd4a701941cd802f3a0e320870fcef7819ca068e1d4d86"
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
