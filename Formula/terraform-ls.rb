class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.31.2.tar.gz"
  sha256 "63e6e724fac47305e777c8360172a4b485fe27cd39fa6a81167ebf8d044b9238"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd1bae54e2eec897b8415ad04ca4832c48bbcc78e93e25d647b67c5c75847b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecd1bae54e2eec897b8415ad04ca4832c48bbcc78e93e25d647b67c5c75847b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecd1bae54e2eec897b8415ad04ca4832c48bbcc78e93e25d647b67c5c75847b3"
    sha256 cellar: :any_skip_relocation, ventura:        "81e72bcef2fa932c8d7976294e5df05f521a46d63b6ec5e463fe718e43385fb9"
    sha256 cellar: :any_skip_relocation, monterey:       "81e72bcef2fa932c8d7976294e5df05f521a46d63b6ec5e463fe718e43385fb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "81e72bcef2fa932c8d7976294e5df05f521a46d63b6ec5e463fe718e43385fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc8da6332292a5f8c1cb4856b436e57398b033423d96f6a29677c2a0b46894c"
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
