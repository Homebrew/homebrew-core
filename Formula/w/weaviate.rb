class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "f987d94ddaf941bcff5f2687ef0cba162125b3f66f79723a6b1c70a740dca946"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a8fcb09de6dfffdcb4ad8a7284367657c729ff990ac6eee55f1bb2313c32b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a8fcb09de6dfffdcb4ad8a7284367657c729ff990ac6eee55f1bb2313c32b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20a8fcb09de6dfffdcb4ad8a7284367657c729ff990ac6eee55f1bb2313c32b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "88167360f28cb85a6f7a304f880a356b5948dd58b34b2e2d0bc597fef79133c9"
    sha256 cellar: :any_skip_relocation, ventura:       "88167360f28cb85a6f7a304f880a356b5948dd58b34b2e2d0bc597fef79133c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db698d07ac25917e5af761cd92069e90b8b138ea8d60da965710e9cd8fcb4847"
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
