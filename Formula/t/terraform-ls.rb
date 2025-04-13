class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.36.4.tar.gz"
  sha256 "c52a38fe5e4a5e16660e24a23d090b85e37a543efa0aaa6cb82238c0bc22e144"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffde394a1ef4f2ce01db0a2accb3e1655688f071ecb04944d32749e4817ee5c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffde394a1ef4f2ce01db0a2accb3e1655688f071ecb04944d32749e4817ee5c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffde394a1ef4f2ce01db0a2accb3e1655688f071ecb04944d32749e4817ee5c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "94612fd0823787c84621378278a1b5d1c353eda810b9aaad08794a4031076b46"
    sha256 cellar: :any_skip_relocation, ventura:       "94612fd0823787c84621378278a1b5d1c353eda810b9aaad08794a4031076b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cded371eab11241e1e47160461535c2809893a0d56b905aeb3a5e91dab248a82"
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
