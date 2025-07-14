class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.36.5.tar.gz"
  sha256 "a5781fbc22c1a1efba5fc4122ede10e1b496dfc18175784cb3cc55b0bcc4c91f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5785d7c7a090b3e4df6662d4733b6ba517873f41d2a436dca0beab836ab9a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5785d7c7a090b3e4df6662d4733b6ba517873f41d2a436dca0beab836ab9a7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5785d7c7a090b3e4df6662d4733b6ba517873f41d2a436dca0beab836ab9a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4898ac6529bd9235a9102425d44ee52734e93254834e24f94794049980b9404c"
    sha256 cellar: :any_skip_relocation, ventura:       "4898ac6529bd9235a9102425d44ee52734e93254834e24f94794049980b9404c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bdc0b2f075758ab78c9e95837f339a2cf3b0fc891dc9818184d6bb096987487"
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
