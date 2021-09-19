class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.22.0.tar.gz"
  sha256 "9915e8384b9b1219b6ac5816ad377b23a7aabd8164159e42f7bf01d8fa93924b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "42be42f242ec37f157067026d3e13bf80cc2a740eb1a4a69fa27a12ff737ee3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "734f3b5f8afa51dd5d54a993c3b7851abe40ed738b8289232502d3fbfc137c64"
    sha256 cellar: :any_skip_relocation, catalina:      "0327001b1e0e1fcbb6b401b633ca26ae8801f53be2748d53bd3f22b22e427d19"
    sha256 cellar: :any_skip_relocation, mojave:        "0ab7669941739d62a7603a09bdf8138f2fe4ae4f64abdbe5f0c6a2134196ba69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f214bd8470d7c42a3eea0dc4095403afda8c164375a713f7eafd3a25070135e9"
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
