class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.18.3.tar.gz"
  sha256 "bbbc4fc033ffe661c68418662b916399990876965dcca2f35ec43d2445e42b31"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c06cfdff3b589cdd95c2428d89e700e4e9561eb1f295999bb319cb7db26beb3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e7cf9592576d24d302de6d079783c8ce457d707952d91e4308ee309b15cbae8"
    sha256 cellar: :any_skip_relocation, catalina:      "172191f60ef6d618fb5b2a70b731c03e090211b4d9136d7f217a3a5ded81aaf0"
    sha256 cellar: :any_skip_relocation, mojave:        "57dc74d11f0b4f6c84f1c4320b1d92498f984d0564e000e09ab2e7917d6d772b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
