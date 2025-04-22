class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "a2584f7f5455ca6637f22000691aa41ff706b6ab7c2f6067ed7d69a7809ada2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6993525e6c405d2d53d7ef0fe0d078de884614facd46f2360be55944790b626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6993525e6c405d2d53d7ef0fe0d078de884614facd46f2360be55944790b626"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6993525e6c405d2d53d7ef0fe0d078de884614facd46f2360be55944790b626"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea9c0c7a5750b84fdde799b1354614af3b0fd70d9df28e403877da81030bec71"
    sha256 cellar: :any_skip_relocation, ventura:       "ea9c0c7a5750b84fdde799b1354614af3b0fd70d9df28e403877da81030bec71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6f9da2a7ffe1087a87096a35bcd0042bbc519cd4b5d55879a2b5dc74c49a3cc"
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
