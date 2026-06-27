class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.11.tar.gz"
  sha256 "135bf20e3b86c986edaca529f3fbe060780c2e9a05f21ea5ff3e090936752cc9"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3b144819d87d620dd5876793ac1130f52298d50746df2dc300ea31bfca0211e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b144819d87d620dd5876793ac1130f52298d50746df2dc300ea31bfca0211e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3b144819d87d620dd5876793ac1130f52298d50746df2dc300ea31bfca0211e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c13b58668a6569254fdea18ad8818284e86b99326aeefe8dc43080cb582b854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5532a9320b1a7c93198816551b1206f33e3f2d42961826c88e79b02ea6efcbf9"
    sha256 cellar: :any,                 x86_64_linux:  "ba3aefab29fd3f953cf3513b94b3eca916f35e3dd6dd2122508b171f2324f8c7"
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
