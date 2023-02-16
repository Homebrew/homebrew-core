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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "579b75052257a42fce6b68c452bff5e9f07979cfd0211d005254415a70846d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a5e9a977e74df26c7efc5baa6fca9f34c269a0d7cb575e61452304bd42dc8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b52fe6d0db9f233d67b9b51d41ee4dfb26ec7a2a9500cb774889509e30592113"
    sha256 cellar: :any_skip_relocation, ventura:        "0915f4bd21bc4ea1a4e039638be2bd498333c826e96d37fbf0aa771c33049cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "7d16fbaf8a588072178d14ba0f411331d752ee0a52c44285a581aea831fc3f45"
    sha256 cellar: :any_skip_relocation, big_sur:        "02f5de096f52091d2b4faf60e361d275c56db7de766aec2c0f46dad6a2a53b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98b562f1b407dca23fa5d260f5f31e18ef14e586a5a77cd4a7e1ae373f8f87e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}
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
