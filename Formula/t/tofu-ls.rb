class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d0bc52c62ff64d69180f34d3afd3af2c1662fb2abfd7b2501c20aacd9ec0ba36"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2d8f16af504aa1c90ce82406a9efc8e2088e6ea15671f9caddde2be60302d2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d8f16af504aa1c90ce82406a9efc8e2088e6ea15671f9caddde2be60302d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d8f16af504aa1c90ce82406a9efc8e2088e6ea15671f9caddde2be60302d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2256eda2b4338cef197a77a978dff0a27e81e73da2e370339b61f88c5350e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889195511b320eb2a74946e39061867f4c9c357642483e8f7c4e57eeaee2c8e1"
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
      exec "#{bin}/tofu-ls serve -port #{port} /dev/null"
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
