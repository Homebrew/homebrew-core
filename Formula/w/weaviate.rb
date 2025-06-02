class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "70df7afd139798657da8bcee20dcb3b50946a25ac5bc26dce51e74afa726615c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "114ee0ce050044c216def57124fd075fb93a5c8f94c84d6c878c844ca809dcbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114ee0ce050044c216def57124fd075fb93a5c8f94c84d6c878c844ca809dcbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "114ee0ce050044c216def57124fd075fb93a5c8f94c84d6c878c844ca809dcbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a030472b1807e2e6aa2bed996a73031a1bca7565277ec8024f9dfb052c99c2c5"
    sha256 cellar: :any_skip_relocation, ventura:       "a030472b1807e2e6aa2bed996a73031a1bca7565277ec8024f9dfb052c99c2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8bc3d71d841c2d85794a312ecce7ec2bfa36bb81623830f90bfcbb88e1d819f"
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
