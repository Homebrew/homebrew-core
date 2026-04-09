class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.4.tar.gz"
  sha256 "3c236581b1073bf175f2d88b1bc91767e07e3976f4ed28d067ab4a0ab48eba6d"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c5d82cd597df48f5e5bb9743dab527cc097b91afc159f87c6b2274d9981b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c5d82cd597df48f5e5bb9743dab527cc097b91afc159f87c6b2274d9981b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c5d82cd597df48f5e5bb9743dab527cc097b91afc159f87c6b2274d9981b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1ae64cc2b28e332593bafa0b62db359c951aa810d931863473b325c0914a00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc6b48ec557b22dae0c24745fa92bcc67965319c54648501369c69d0cf0d0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30fee1e76dd3751f40ba1bb9ce5f83551bb4ac766ddf47d7e3db07cb70d1e069"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hacdias/webdav/v5/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"webdav", shell_parameter_format: :cobra)
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
