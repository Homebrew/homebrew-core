class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.32.8.tar.gz"
  sha256 "90eabcbd7a29d569e05de8ab471ea2f44d8698f694f07f50a400d442a2004114"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad8debd4a9b9406f677edbd4a193cd812906128488003adb1da4570c6bb1b63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a459c121027d7d9c19dd0f19a1365c67178ddc8191eccb6c1b838ca10b0948"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f346730b56a8c82d1c2db2e4d1d75e5098693dec66980648bf39dc2ee4e2eac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7a90aaaf0bb6bc6f2a4f7fda54768ca601b15e240112953e9e157fbbeeb0000"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5407a13f52589ca2960c20de3536c1195a49c57c12ece19829e15b1eaa9f75"
    sha256 cellar: :any_skip_relocation, monterey:       "d384469ef0a93e4b2310a4b331ac25d02ef0668b7b15c91f9e3af0ba6aed57bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e778ffbaf6f93b86de1a76543a7cbd7cf5c96031bdc6b1a57091127a2f78cbd5"
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
