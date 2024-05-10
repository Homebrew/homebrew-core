class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "1a67511bdf8a13222ff749f0fdbdf877d474d94823481e7568f97c3f75fb6035"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b4616feeeca2e0aaaa7c61b19f271d164461ee72da9f5abefbd534e4046367b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08fef363dd726bff09b63b10451013a38ebf0eeb2505a480d57b9cec26967fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e613b2120091c25de97eb8540f5a3629048493e0dec96e6697f25af9f5685bcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "66efb163a22af9f007d147e439b11c7b83df7bd7522b8279e5f217d6c66f993c"
    sha256 cellar: :any_skip_relocation, ventura:        "bf23ec6d173d007c44cae7bca454a61907bf190364817288f998910c4d284369"
    sha256 cellar: :any_skip_relocation, monterey:       "579d85f1b498d29b21e8d260510049a7006ab1b7342fae26c485c234b4d62752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a943c729145cd6e2189ebfc0ac914b77171cf5b2786cd04a5553a8ff27cc9377"
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
