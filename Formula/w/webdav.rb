class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "77f40c292556092128ef7954788ca1b93228e0dd88d9ce89e179e38e9e564d52"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34f38d15cc36a519cbc5f066f39c1fb735b880c5a4b1401f2994f0fe972a4c82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34f38d15cc36a519cbc5f066f39c1fb735b880c5a4b1401f2994f0fe972a4c82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34f38d15cc36a519cbc5f066f39c1fb735b880c5a4b1401f2994f0fe972a4c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "601f5ffc6b5c3a6a83e586af61aaea595240f5edf5caa2bfbc69ec85d2cb42a7"
    sha256 cellar: :any,                 x86_64_linux:      "e2239a3ff0f393c08ccc4b0689b0da77c10dab4cbfcb7294f57114e14d8ad677"
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
