class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.6.tar.gz"
  sha256 "258a415729703c2d988286c480bc4242d6ccc15ca49a92abe53c3b637ae56c84"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b43f5ff63bfa6266a6f9d12e01150ef2169bd40ea7a6fc1e80a6951e801bcc59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43f5ff63bfa6266a6f9d12e01150ef2169bd40ea7a6fc1e80a6951e801bcc59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43f5ff63bfa6266a6f9d12e01150ef2169bd40ea7a6fc1e80a6951e801bcc59"
    sha256 cellar: :any_skip_relocation, sonoma:        "edfe4c027b6eacddae2880ade07a8386f6b8ab781b4ea5709ea38e00fc2339f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640c05456b93424859637671ec9939633a1d8f12a59bfa4e84b2f16ec341a6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2130634b210e8220e937cb3ecf36585c3896af11964a912ad4e133aaa38cc65"
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
