class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.14.2.tar.gz"
  sha256 "aeaa640929b02d32645f5e856b7ac1f2eb282562496a2c207982113cd6fc607c"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8319524bbe49b2becc8a4618da1c27de2006e78f0e1155ac5347b65ea07119c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8319524bbe49b2becc8a4618da1c27de2006e78f0e1155ac5347b65ea07119c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8319524bbe49b2becc8a4618da1c27de2006e78f0e1155ac5347b65ea07119c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "862dd9886fe3cd51588f797d5c163128e9309ba5ebb48ffc6e114725b57dd046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c664d194d1f4e51031f8d00946f9ad6b43e790dcbf85acc8ab7fd90e1e443c"
    sha256 cellar: :any,                 x86_64_linux:  "39f89743e2ab31c4642235dc49d5abbb08726bea2cf37256ccefa1725c54c3e9"
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
