class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.26.0.tar.gz"
  sha256 "e4d67e3faee34a4555fcd8e68aa0a18a5df8669edc0e2a4d3c04acbf80d2d5c3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea40aba18df55b9409db36a3b894515440b0597962813c9a7a09d607a133f10f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7547d9c1533868f7fd7841c0b2839b084e1b790225003c362af29d249bf43746"
    sha256 cellar: :any_skip_relocation, monterey:       "6831838f679f67f3c98a43eb08da8874f5194f9155035b1bb98ca49844efbb05"
    sha256 cellar: :any_skip_relocation, big_sur:        "31ea39566dcf8abe1d5b0251fbed1300bc5968ebf26c637e35ada9c9e8ef64c5"
    sha256 cellar: :any_skip_relocation, catalina:       "bb17a84e85db5e39a50c5d9c038105c6792c26d1df640bf10f35455609dc748f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "211a611a3eaf21ec86784bacd86101c25bda4bbfcf6e7cbc06b4d41b452c13cb"
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
