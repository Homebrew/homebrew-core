class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.10.3.tar.gz"
  sha256 "88346b6b0ef4db4f8d20f21c83a220515724b0318900481825b6e4f2657ddd3b"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfdf7f9167caeceffdab045bfcb15c6bff72fbbf47f36f1e725b918b6eb4fd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfdf7f9167caeceffdab045bfcb15c6bff72fbbf47f36f1e725b918b6eb4fd95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfdf7f9167caeceffdab045bfcb15c6bff72fbbf47f36f1e725b918b6eb4fd95"
    sha256 cellar: :any_skip_relocation, sonoma:        "b842733f6cdef3e1c23e5a920b67291d793898f94ee8e3d9a93f4f7e4bbefd53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6f3361d40ec0e1dcf1068d5aa557dd150f3acf7a51389b24cee37a0a98a20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "483b40512680c4a5bbccf4eb475065c20d4459dcfdba29dcb13f21b01baf7ded"
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
