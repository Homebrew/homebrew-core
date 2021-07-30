class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.20.0.tar.gz"
  sha256 "13d44f376d8420c93f3a695bbe3f5429385cf9dbf822c562ac38e7d4ea3162b9"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b7bca90ae844919447fac9cfdf2e9c19fe8f7a92f596ba62ba348b5e793631e"
    sha256 cellar: :any_skip_relocation, big_sur:       "db907f2dc57751cccfb9f08f1b3f9367b1c8683a1d026b281a2a7564b88b76c5"
    sha256 cellar: :any_skip_relocation, catalina:      "077bedc6421fcecad7fd81037f0f8f0d00c020ccac1788d999f619a0b18b06ad"
    sha256 cellar: :any_skip_relocation, mojave:        "dab8f051ee7a300f2024df44dd8b7bd040b7008806274a4ae49f9bf180f87dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6b7afac12327fe9c6f2b4b8649ce462ebb8e6b2ccd2cef8ea5bb2c50e312bc"
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
