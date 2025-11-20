class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "7f309f0eb1ef42386c9bc29d0050d2607c456cb08ad1fa5966b04790c4779a11"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e22dc5c03073df6d2cfb6327ddc9132130fcc31753621ffdb5c7d4fa87aa78d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e22dc5c03073df6d2cfb6327ddc9132130fcc31753621ffdb5c7d4fa87aa78d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e22dc5c03073df6d2cfb6327ddc9132130fcc31753621ffdb5c7d4fa87aa78d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa0bd88c9a2579fa25b2ab37a9f8c063619308153406bf52d24ad4c57553b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008feee1598ebbcc0450e7ffea44bc8843bcaaf757ec2c6e80a70e1e40912026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52adac219fbde5f56abe43322ad66a0379387fc6aa663e512b6d1c5c03d3c4d"
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
