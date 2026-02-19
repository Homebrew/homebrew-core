class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.4.tar.gz"
  sha256 "698968b3606c422750fedd9d8a038ca3d0b7f57d7503d7ee60eade56dfb3d31a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dceb13f2502255fbcaf74ac3c16b5526344fd8f4c25804710116bccf1ac8055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dceb13f2502255fbcaf74ac3c16b5526344fd8f4c25804710116bccf1ac8055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dceb13f2502255fbcaf74ac3c16b5526344fd8f4c25804710116bccf1ac8055"
    sha256 cellar: :any_skip_relocation, sonoma:        "149d9cf9587c805d26e06437e41b1ad9ba930a0bfd1a1aa8f6c314d4a621fe69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9118113481fbfabb7e664692ff4d3b51dedfb88624ea4b15d9dcc173d585e382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9456f71f1cb7c25b07e6ced741099dba619c982a57c35fbcb5dbc99533704f13"
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
    pid = spawn bin/"terraform-ls", "serve", "-port", port.to_s, File::NULL
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
