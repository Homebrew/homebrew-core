class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.30.2.tar.gz"
  sha256 "ce27c6f42f107159abbbad1bce5af186d7ae9150aabd8042e4b2b79cb15c0b73"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22182da35a0832c277d0cb4462bee3f183b5d611f345348464d731f1e18d4cd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3f3ffc4130db7fcd72f3fc74d8427625fba691c0e83270f83f0fc1361b4f51f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64565962ee59194622a1bc93ca3aa1738f3399584267ab7482ee13f49aed2738"
    sha256 cellar: :any_skip_relocation, ventura:        "5acd38794883dbfb7475bd50b02475c3365af1c84708604a5ca69ce574d55750"
    sha256 cellar: :any_skip_relocation, monterey:       "e6df5ecad0fe7a6c9bed5b3e445a2c62659b4c44ba0bcf7576e2d17782331bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "27313680dc76bd2fd7caa1e6113199d2205e88a123e59791e9753d08e2ed16ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a87c457edfdadf2544ffe55ecef94de919997a14d0de1ce2cc5e071e5b6e3b6b"
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
