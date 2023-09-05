class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.31.5.tar.gz"
  sha256 "a0221fda9ed55093279bb4f3bf71f7e937b3b60efb972c21761e5c1b8d607b53"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99574ab8340326cea2a53421039b393803757c08bf20911fa5b518123305f513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2732ae7b00a7982bfa9f47d67c2ba655edf7f26108a3b25d2df05abbc4b7487d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e7e98f44b58bd8fe5d530d63fc21cfd9b13ddd51246716c4c88abbeec7a690"
    sha256 cellar: :any_skip_relocation, ventura:        "9a56133d92f9512ba6ce0716150b3e05f0313c541eb00921e2c035923c85ef3f"
    sha256 cellar: :any_skip_relocation, monterey:       "24bb5f147fab31a8b492850673ee6c1d1ae601e4625c941a93fe558fa6a0fee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d92a9c98fb3d9c629aacb5c6958aae4002d669f10d22e00513f3db81ddae14d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a304cc1cf9881b5d031cf46de2a91315bd0a9de4c201e9aacfd482bd6bf71a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
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
