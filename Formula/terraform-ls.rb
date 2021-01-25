class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.12.1.tar.gz"
  sha256 "796577a1b9da762d284b1765a033660670ed607c62455adb3299dacbd90cdb2e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b6c3b8fd09b11f785529284d947894ae20907c18ad5784c7bfdc3b53e3875e9" => :big_sur
    sha256 "077434a34498a60299978fbc61b791ceaba4bf6b0a59baf5dd02deeb77d11895" => :arm64_big_sur
    sha256 "716918f69f13a96abcbc3d4f5250b24e6f0f0b9c606c98afd4fadb7517901f83" => :catalina
    sha256 "a32cb21629c530e0427e60c0b121f9b5171a8eda9bc6f56e36e14244b75f9864" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
