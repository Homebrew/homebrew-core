class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.36.3.tar.gz"
  sha256 "b8d23129e92d6f481bb2b6dc94957b34c0d99b30f0e63a0654903c5cddcf4707"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e685d53254f9e75c5191a20dcb866898f606ed108aca741a63f7ba64c5b76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e685d53254f9e75c5191a20dcb866898f606ed108aca741a63f7ba64c5b76c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40e685d53254f9e75c5191a20dcb866898f606ed108aca741a63f7ba64c5b76c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae2c0602df98ea7c3e2d78c6cac88bfef2e1dc5643ea5104b5b0c2c2999a491"
    sha256 cellar: :any_skip_relocation, ventura:       "8ae2c0602df98ea7c3e2d78c6cac88bfef2e1dc5643ea5104b5b0c2c2999a491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82a00e114e0f29fa61b911cfd6fe485f917ecd76e5588a6465b4f95005726e4"
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
