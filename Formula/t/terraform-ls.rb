class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.32.1.tar.gz"
  sha256 "97b65deec4f01586ea13fb501b9f41b176ca90991f44580209249d0b0b249501"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2d2a51b3ee7e8f7d6f43fa6c36e5f42207b2707cab459916510a02353d6f7e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92a9733698cfc71f8bc1d97fc9805f95ed7992bd9f3397ab7980010ec8fdb556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d0a2504a29285e756c1a0ab371f80433210a12a9cde124b90d3ae1aea6b1eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5a8fc7edb4b65894ea271c3e8d9a11bf86b2ff56e85aace941ebb8a5de6bf45"
    sha256 cellar: :any_skip_relocation, ventura:        "40d91ce4329b6a1624cb6462a1f36e49cdc91105bd4eecb7adc5583fc3b13470"
    sha256 cellar: :any_skip_relocation, monterey:       "522fcb7060083c83d6b6f16e91c50da81d7e58f3b9ef16b01815e8db9996796d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a433c3581d9363969c75998b21c3685b8fcb0bd8c48c234540177ef664e518c5"
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
