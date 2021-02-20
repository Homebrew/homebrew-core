class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.13.0.tar.gz"
  sha256 "7962a30cad982794ec6976dca130908acbb081355ba57b807ddc7216726080a3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3629ebc8543ab98dd8a02a77ccae3e47575e31965441fdc8fd6c035bb30f72da"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5694059a150e38151efda727ea648e6138dd618efb287ad0e86666bd75e9fe9"
    sha256 cellar: :any_skip_relocation, catalina:      "63fba7d57c5b7504463ddd4f207aa00911afa78a97e3a1d97153bdb53f2c373a"
    sha256 cellar: :any_skip_relocation, mojave:        "e796d66cbf4bda8dc72ddd1b00b69e804e73132bd66a7af1ca9eb4f1354df2b2"
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
