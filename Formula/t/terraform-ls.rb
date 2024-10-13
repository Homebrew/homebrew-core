class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "9398c67647a57738fbd81cb97fd15d0916fec9c1954820ee7e8ddb6812c09e91"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "74a6d2e45686d8552b2429d079dd3c4e9f260777f2f34bd49e122212808784ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b50a181e9f60068d30d6d1f25ea1fde0c5378f9d27830a377afa055704397392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b50a181e9f60068d30d6d1f25ea1fde0c5378f9d27830a377afa055704397392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50a181e9f60068d30d6d1f25ea1fde0c5378f9d27830a377afa055704397392"
    sha256 cellar: :any_skip_relocation, sonoma:         "38826dee02df48b8ddccd82efb238402585c6eaa5715af09e7e48db69c9908af"
    sha256 cellar: :any_skip_relocation, ventura:        "38826dee02df48b8ddccd82efb238402585c6eaa5715af09e7e48db69c9908af"
    sha256 cellar: :any_skip_relocation, monterey:       "38826dee02df48b8ddccd82efb238402585c6eaa5715af09e7e48db69c9908af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d93df2febe7a24955317d2497ed43c707619d3b3788843c89d68af810682f5"
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
