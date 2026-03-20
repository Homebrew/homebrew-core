class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.2.tar.gz"
  sha256 "75c6c2339237886d3745e0efd760de20a4b16add3543de9eb50ce3603151e5b3"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fbf374d4ce39d472223d4e4154da09d1d65741f4c7d76d2304d4db521e537b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fbf374d4ce39d472223d4e4154da09d1d65741f4c7d76d2304d4db521e537b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fbf374d4ce39d472223d4e4154da09d1d65741f4c7d76d2304d4db521e537b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "380d31b7418004a41b55cd0131ecedfaf9414226e72c8f490ca2a9099d91961a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41d43c54c8b2fcdb589f2f47d1a859bbcedb988f602358b324a61f30f22a5a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4e26936f7e44757f531192a6e9acd8caf00a1d19ee21eb8eff31b2b7d893f9"
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
