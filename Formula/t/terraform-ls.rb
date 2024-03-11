class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.32.8.tar.gz"
  sha256 "90eabcbd7a29d569e05de8ab471ea2f44d8698f694f07f50a400d442a2004114"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79b07f18f8c7588a4c553bff7b7f91b25a3fe3aa3abeee877313695ec4039e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b99afab64a468afdd1cd97b22662a70db8e90a45d7c3f16c4147791054f6fde3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39f877c3a6d92fec482cfca88f43d053d783649cbc1762b77a5cb36c0593f12b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4885e3abaa4657fa1d97588a782abcf0024520d4a8d8611d9ded95988bb995dd"
    sha256 cellar: :any_skip_relocation, ventura:        "e7343a2bc89a023ebd06004e0558338ce924bd337e469f63f399c60e4c8e2220"
    sha256 cellar: :any_skip_relocation, monterey:       "52d307990e38382e484f52c3cc42ab7d1d7d6cbb6a3a124671bfca0450712c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac739dd5c0abbd64bf5bfc10f16ba82f50436c8ba308ade5055ded298f1a1263"
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
