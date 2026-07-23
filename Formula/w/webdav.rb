class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "7a72d1281fde08b10e9f5f83c694ba00e15480b6f36687a58f08c7964352f1a7"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c56dec23991b915c5e54eb1557a1476b6e947d74e1f35ee30ec683b2cc4e07f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c56dec23991b915c5e54eb1557a1476b6e947d74e1f35ee30ec683b2cc4e07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c56dec23991b915c5e54eb1557a1476b6e947d74e1f35ee30ec683b2cc4e07f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0c1599b0d679c44113c187cc98cf514dd3b746e04ee9a33fe76f881d8c2aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba0588fc6a86b26c216256e037dd1ba5ce7a382d8e67d5dbd46e6e71363b645"
    sha256 cellar: :any,                 x86_64_linux:  "2933c7755e219433405b79e60198274a092822f4464501ab7e958c7f0e24b353"
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
