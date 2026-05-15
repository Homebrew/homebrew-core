class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "02cfc1ce392cb7add84f37f793ef979f15c60b91405ff237c6bbaddfdc99a028"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2afe10858a4df665ec18fa4c2c7df8bc280a20733dbeb8cdfd10a4694a30b01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2afe10858a4df665ec18fa4c2c7df8bc280a20733dbeb8cdfd10a4694a30b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2afe10858a4df665ec18fa4c2c7df8bc280a20733dbeb8cdfd10a4694a30b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6779bb0b67d17a909c3b267e98150e200ee8bfb5f55fc7ec577a87eb4774ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f7cfaa4783759f4f4918523670304c5c1a0179877fa71f28d3b3bbc4ba50f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52791a62f5f4fb7285c8753ea62d7fb96cc7b6e4f408e519a91a41e698b6d99f"
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
