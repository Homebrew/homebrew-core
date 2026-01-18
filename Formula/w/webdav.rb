class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.10.2.tar.gz"
  sha256 "7bc1535e054e3909c203299eb949665fe1ae50d6b87fc26ea8e1eaa019965fd6"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae1bd9347cac2636204fea1d640dae22494a7286d1803a9e471e563de6335462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1bd9347cac2636204fea1d640dae22494a7286d1803a9e471e563de6335462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1bd9347cac2636204fea1d640dae22494a7286d1803a9e471e563de6335462"
    sha256 cellar: :any_skip_relocation, sonoma:        "878b1ef609d7a81c2f17e07bb286562abbb3e7c9f41a4e7bf66b690c1c6b6e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1386ad2a86ab7e82433f14009f78bd1e0789b7a5ba81c4a38d0dddb2acca71c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa211edf9a4f41a9d41549b1dc81fe61eee588f2bded6ed82b12a066985e4ad4"
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
