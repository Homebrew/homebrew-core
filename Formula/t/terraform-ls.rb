class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "379fdd6b31ba4c58e6f1b966ff9662386e9f59eeb08addb5f64d69268dfd4294"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "636ed065d2adaa055919581cf17149476334f6a2b28eafaa277cd6da0c249262"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07f96134e4ac2e904290c22fbf6219afe280c7230adde65cced38192bff8216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d150f970c135f8747f886de93a9d99f385f505504edd59b778fc21e8bc04344f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9324bc5f6cc1d514ad72a5f81593a94343ab75c89ad1fc6d233cd9c6aa463ce9"
    sha256 cellar: :any_skip_relocation, ventura:        "117a27ce0cd351802b73fe87079f477f242db343f5e3ab726a6ca35e7e78c1d0"
    sha256 cellar: :any_skip_relocation, monterey:       "139445105bc5f35ee3150946f464212c31d49cbf43f63f0808945b74c8a4bbcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f23903e73e4e185617ec30057c24b4cb028e3810aa28c3bbf7e41bc38b605ea"
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
