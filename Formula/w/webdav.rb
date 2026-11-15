class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.17.3.tar.gz"
  sha256 "326b3ceac4dfe8980b6afc6592076afc2a5b753c8586e615e5f5f13af3147e2c"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43a469e15ae16f663ebb209d150cf31cc3c3cdfa640d9c03637a40fa566d9425"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43a469e15ae16f663ebb209d150cf31cc3c3cdfa640d9c03637a40fa566d9425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43a469e15ae16f663ebb209d150cf31cc3c3cdfa640d9c03637a40fa566d9425"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0b44b8ead257b23f259b1089548bfed641f3b32bd2ffbd278d6a8f41794f2bb"
    sha256 cellar: :any,                 x86_64_linux:      "2fb72aa1a8425b7152bf8b62d871856af9e6f4a048ff9580b9be8026d7cac09d"
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
