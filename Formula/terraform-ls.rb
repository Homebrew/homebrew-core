class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.31.3.tar.gz"
  sha256 "0175823793a95fdd96a5426d2e675054b0e46653f890ca0010887dd62f2c0e7e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef04ffa4fe206a4f1e416ecf4e8932c3d0e1e00ff23b98ae22691b54aff7d8d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef04ffa4fe206a4f1e416ecf4e8932c3d0e1e00ff23b98ae22691b54aff7d8d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef04ffa4fe206a4f1e416ecf4e8932c3d0e1e00ff23b98ae22691b54aff7d8d1"
    sha256 cellar: :any_skip_relocation, ventura:        "285be621bc579696fd72126f9e493060f3acb8fcc6f1f762b524332f70e7ebb6"
    sha256 cellar: :any_skip_relocation, monterey:       "285be621bc579696fd72126f9e493060f3acb8fcc6f1f762b524332f70e7ebb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "285be621bc579696fd72126f9e493060f3acb8fcc6f1f762b524332f70e7ebb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a423e6101325628167a9ac1fe042ece92dbfcd6319a9aa3cd3c4acfce7e3cdea"
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
