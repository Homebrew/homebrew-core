class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "c261f3574d891dbc0ade46f7892a503fe8d4e7519bff5037b3a42a93255a9350"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffd777c1dfedaa16345c77970c56c052b19cdc7ecb5ed659d14bde420ea50da8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d078e6270298fedaa346389dfe1c6086a573d5ab13b7c8f5230992ac15709c5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caea15061547ffff07be6e7c5fdc7b87becfd4724e49d1348fec48ca6d71d5ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "7adcec8f005e943eadd2fe1f4330f6c8ecae70fdf84cdb457df5aae8cb4bdb27"
    sha256 cellar: :any_skip_relocation, ventura:        "718ced922ae49e95e331d09997b1ad1074947a37c53db540dc37ca437b7904e7"
    sha256 cellar: :any_skip_relocation, monterey:       "18d18cae1f5ec606606f80c1851a272dea01d4be2683092c57d22e409a2af08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "915ee483c8dfa4d2d081f730ab0ff6cbb60533e4061446a4dd76f6c6fb015fc8"
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
