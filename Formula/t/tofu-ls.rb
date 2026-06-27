class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://opentofu.org"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "6e6ba0f69a85cd9cc59a545c8fe6fa85ffd1ae0fe1989422cc24b1c05f08a5f4"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b10ed4b24d92fd93fc0b6f2ae0790db2e0183f22bd4c204fb3a4015ccb11ae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b10ed4b24d92fd93fc0b6f2ae0790db2e0183f22bd4c204fb3a4015ccb11ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b10ed4b24d92fd93fc0b6f2ae0790db2e0183f22bd4c204fb3a4015ccb11ae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2aaf58619c8949ad96354c935a97f117194436aa8331c62e90236149f86e188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e064cc99baea4257d0ed61ba680cd8dbb265038accd835b90cc646f8709459e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b7d1f2a00f008ac350f19f74b165fad0e8c19cd682760bdf335a94f5b95525"
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
