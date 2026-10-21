class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.17.1.tar.gz"
  sha256 "2ef3605a0d52ffb190ed854630a0e2c8772cca8788375558b7f25153c981b622"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a50b7a66318966c3aa9555248571d937ca36fddf531159215b75ad644c7ad074"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a50b7a66318966c3aa9555248571d937ca36fddf531159215b75ad644c7ad074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a50b7a66318966c3aa9555248571d937ca36fddf531159215b75ad644c7ad074"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6821ae5fbfdcb5e2e20268b98152d23ebfaf19581a63c7d012b27c465c0f7095"
    sha256 cellar: :any,                 x86_64_linux:      "ba9d46fce8f6d153ae3ba3cc16adb49f660c4ddfd18d3cfe3df2e08c00717cff"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/hacdias/webdav/v5/cmd.version=#{version}"
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
