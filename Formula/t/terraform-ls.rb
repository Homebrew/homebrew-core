class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "e118fac0f125a54425c7d007fccd4f7c75a25b6eb563dd88ef28a4e866777492"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc8bc300fb7c3b1e89d9fd71e6e13a50e84fe7b307836aea385c60c67bea38bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6010d80fc7c003b32e74d76e1b7793b7068cf06499eeed7cc85c61a91da95b63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a06d262d23d79821f8317e6530b86d4eab548b37d969cbc0e799ebfed7f68a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "66ca5bb22017e5eb8a8b75a46d29ce652843d106dbda36404bc39623939c7ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "3b24a3b8bbda2c086063da2d76fcf27d332f3c5ab6a326413fcef60bdaba73bc"
    sha256 cellar: :any_skip_relocation, monterey:       "34c8e8e24213b0fa33cc9dc87c3b956e692ab8197bbec7934f1dff413abc4bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c5a53f7c05b9785d8b07ed3748e830a96632552aebc1bdf5c6edfbf6e65eca"
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
