class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.31.0.tar.gz"
  sha256 "4ddb9e33a8d0f8ede121581116f6683426cefb7bef099b49de8a3bcaddb7812e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "514886888a75581105f66b015ca3d8b5b4a9bebce6bb08d4e7b099a022afbe84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "514886888a75581105f66b015ca3d8b5b4a9bebce6bb08d4e7b099a022afbe84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "514886888a75581105f66b015ca3d8b5b4a9bebce6bb08d4e7b099a022afbe84"
    sha256 cellar: :any_skip_relocation, ventura:        "65d1b4fa24d0b3fe37ca8a0b1cd95a63bb9b46e0d126413d170514dc01e5fd07"
    sha256 cellar: :any_skip_relocation, monterey:       "65d1b4fa24d0b3fe37ca8a0b1cd95a63bb9b46e0d126413d170514dc01e5fd07"
    sha256 cellar: :any_skip_relocation, big_sur:        "65d1b4fa24d0b3fe37ca8a0b1cd95a63bb9b46e0d126413d170514dc01e5fd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204a7a3a902571affc8742924a533d7200a4b425245aa280245415339de6e434"
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
