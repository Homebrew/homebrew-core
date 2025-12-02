class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.3.tar.gz"
  sha256 "97f5992c57d6cabba72b3ffb69f18c953001f273ee7f24d56603b601fd3f7a40"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7fa54d363c947a64e382b72a63e840b7d4aaead3a8ffbb68896e2d2b49cb7ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7fa54d363c947a64e382b72a63e840b7d4aaead3a8ffbb68896e2d2b49cb7ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7fa54d363c947a64e382b72a63e840b7d4aaead3a8ffbb68896e2d2b49cb7ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cfd5918d649e22df75a1e588b1fa88119214196ef25ab7d49726e9ddf28eac9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42731d40f4ef1e90de257a1b542eeab596dee4c5123793d3c8a61ca3eb781c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15a7180b5a831c7a5253b69053462d9d7f43e571360aae2c6a1bfb0602f54b24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
