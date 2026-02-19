class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b9b80e4ba237187a0a4f158869d55e2aad66ec47446ce12880fb4ebbb28508f6"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "357ccd1bb00fc2383d210df836db6d91cb0b3d98aebd3c098d391e08709ef5fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357ccd1bb00fc2383d210df836db6d91cb0b3d98aebd3c098d391e08709ef5fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357ccd1bb00fc2383d210df836db6d91cb0b3d98aebd3c098d391e08709ef5fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0702775a12d5a8c420780b1dafe0d31f7a16455e1058f6f539c9b4900b690d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096bfcc33d92da2690fb3985e855c1ee1d4d6ff45e3f1f44ad40296cd592427f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab98ccfc37701a33465bddc81bf83bac23eb4b6247f4f8a91bdf3c52d7ccb74"
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

    pid = spawn bin/"tofu-ls", "serve", "-port", port.to_s, File::NULL
    begin
      sleep 2
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
