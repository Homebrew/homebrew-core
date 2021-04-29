class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.15.0.tar.gz"
  sha256 "1efa538816c8678fe1e1243bdd99b913056d64826d631dfd7a6795c37573ed97"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e9d6445cf5938f99875502ae54b4606753c0907f156add96f04caa702297e6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fe947473789a6d477cf48de8d1adc3c73ca1d47fd6a3afc1a8b036882429480"
    sha256 cellar: :any_skip_relocation, catalina:      "93d8e68ab5d2e2328a5cd5713d7405a5941339c9d7ef3c05e752a8c11054e11b"
    sha256 cellar: :any_skip_relocation, mojave:        "9671d6c63181e63b3d5c136b9ca2d50b1c196ce23439cee65ed90a40dda5b56d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
