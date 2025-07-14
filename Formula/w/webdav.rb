class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "fc9e5272c821f5a4ca98321195469a87a9ba8a8c696c0f4d3008407ee8150039"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf72b71abacfc241a374cb784db63779bed55040b4dec593d8fe4c35177331b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf72b71abacfc241a374cb784db63779bed55040b4dec593d8fe4c35177331b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baf72b71abacfc241a374cb784db63779bed55040b4dec593d8fe4c35177331b"
    sha256 cellar: :any_skip_relocation, sonoma:        "061895843ab8e5c0174f3456a265eeda0cdaf3a94509a6db1c5d86848910d6db"
    sha256 cellar: :any_skip_relocation, ventura:       "061895843ab8e5c0174f3456a265eeda0cdaf3a94509a6db1c5d86848910d6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf0b783e2adc344c36b94769f905517878de854f8eb4929238dbb1985284ac1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hacdias/webdav/v5/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"webdav", "completion")
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      address: 127.0.0.1
      port: #{port}
      directory: #{testpath}
    YAML

    (testpath/"hello").write "World!"

    begin
      pid = spawn bin/"webdav", "--config", testpath/"config.yaml"
      sleep 2

      assert_match "World!", shell_output("curl -s http://127.0.0.1:#{port}/hello")
      assert_match version.to_s, shell_output("#{bin}/webdav version")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
