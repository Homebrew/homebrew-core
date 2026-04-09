class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.9.tar.gz"
  sha256 "92c5746ad1a55520bb2798cf54a13531568f6fae58ef89a6a3a155b1d8c8cb01"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f2cf30d5b5f25fc2e581898b6039b260db70c2c7b7ce2d798711f56f837ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8f2cf30d5b5f25fc2e581898b6039b260db70c2c7b7ce2d798711f56f837ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8f2cf30d5b5f25fc2e581898b6039b260db70c2c7b7ce2d798711f56f837ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f339ec53aff467215b462b988827c3fad85caa0945b67a4a9559559d9021fd60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd962d7428f2b149f791fb303368f55439c5b0ca3f8daf6d8cb8e135d2ea1e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d5ac96a80c630216f8440bfc60f8c0e16c5a4b99435f2ae3da8a040b93e5041"
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
