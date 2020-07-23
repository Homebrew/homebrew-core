class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.5.4.tar.gz"
  sha256 "871b4594f2d4400ea8f06ff0c97270d1dce01899927f7d5d0b9d881d75b36fb8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9f4ef5882e08a1577c8ea64bf077cc264779665da1e15f758bf620192580236" => :catalina
    sha256 "be4e36ecd104955503d86af5e0cc0d7a62877d4db3bd3deb885fc1c241ecdd37" => :mojave
    sha256 "5f7991cf7eb3142b69acd1377d05858f1ac8c1af27da9ad2e1c37df5f1d76b89" => :high_sierra
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
