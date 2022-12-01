class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.30.1.tar.gz"
  sha256 "34e875f555d7fe2456d332f0dd36dd38bc9c0a219d4d904a8c437e90eff53022"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6a3777d8108af454680087865081b3732ec2bb69d02a2c9461174672479886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4e3bf3d1050c98f9370ef218e64cad548e5959a3fd4d2d7994ed87095945214"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e5939646d5f1e5ebdbffb16ccbf624f6bbc18c80d625e861fabd7b3afcc8b7c"
    sha256 cellar: :any_skip_relocation, ventura:        "2c1263714630f1ae96c75e4ca18dd9f554f506deaf3904e2bafd46156b80e5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "523c9e77595c00eb9ff483ae491d62b8469b9a1a7b407f2488fbf9e30e5d322b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f4f378671404497329c14b253a654b4874677fb8ecb97504b5a87b45fb859cc"
    sha256 cellar: :any_skip_relocation, catalina:       "c75b00273c3002896039e711eb3e31e9b69e5a4c99955b2104135ac402053b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1288f5d6306a690cc599dc987fb39fe26f0a81d69b28f4e2d0687e207a089b15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.versionPrerelease=#{tap.user}
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
