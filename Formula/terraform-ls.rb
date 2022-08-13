class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.29.0.tar.gz"
  sha256 "d7017ddc1c1c19dac9daed9f427923273efd86057785b3d94b3680f917894701"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90dfa847979f5c36927117052c2d1dff56e0f3f2d72dd7214631c21a01955625"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c14662c2b1437d49ec728f678e70196f87fdf4d0ccccdb7afeaf94822324395e"
    sha256 cellar: :any_skip_relocation, monterey:       "3b35ba0ffd928ecdbba8f1cef89618353b26db1b6e2e6d22e4b4f4be7b9d6dc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b038424c8754a0a226d062b5f9172ef686e1d77ea890d6588e4ea3e8c93f99e4"
    sha256 cellar: :any_skip_relocation, catalina:       "510a08e0afb4b0b572bd2106d1df315630df93d3b2872e2768bfb746c629eddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebec9315623295ca60448bfced33b46a64eb118cf6659b621088e7a71f4d0e9f"
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
