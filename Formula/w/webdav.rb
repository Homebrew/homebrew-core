class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.15.1.tar.gz"
  sha256 "ec00b065c2b9ddca63b8e4a3c2aa551ad49b192b5e12537c771f70a96a346f52"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a76e92bd7a85faccc0e39ae9c495ef2e843fc30b798fc124b310ea70e2e6437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a76e92bd7a85faccc0e39ae9c495ef2e843fc30b798fc124b310ea70e2e6437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a76e92bd7a85faccc0e39ae9c495ef2e843fc30b798fc124b310ea70e2e6437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da62499384b13cd1a1ea71cbbfa4ddd1700f1feed306ff0a67c7373e2d52bbb2"
    sha256 cellar: :any,                 x86_64_linux:  "e5405f7464a72f772fe9df8a3107c52adeefb97965bd3221946def8c05b33753"
  end

  depends_on "go" => :build

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
