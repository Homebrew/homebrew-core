class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "390604bf9be07ad4b49178320eeb20864eafe86cd0864113d02043adab6be229"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a55102d4654f177ee2225e087cf69b6f2822fbd0e28e672a98a6f1717e7c0ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55102d4654f177ee2225e087cf69b6f2822fbd0e28e672a98a6f1717e7c0ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a55102d4654f177ee2225e087cf69b6f2822fbd0e28e672a98a6f1717e7c0ba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c41b88806a22ff9261944fa35b24d04bc0b7dd7e87fb3809a7c7a0104453db"
    sha256 cellar: :any_skip_relocation, ventura:       "19c41b88806a22ff9261944fa35b24d04bc0b7dd7e87fb3809a7c7a0104453db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23ab067d45bed7394bbfd0fde4ae52b24ce13870027f5361f80499a985487d78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
