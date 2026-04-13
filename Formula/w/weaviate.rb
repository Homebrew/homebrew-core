class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.10.tar.gz"
  sha256 "418ed13ccc0a014ba2c3e46c91924129e189f37797629afa2c6014064ac63ec9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b37e15b97ca31d353ad85f6da90f2cb79fc1ce2c4e2d0cfcfa504552d95674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b37e15b97ca31d353ad85f6da90f2cb79fc1ce2c4e2d0cfcfa504552d95674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b37e15b97ca31d353ad85f6da90f2cb79fc1ce2c4e2d0cfcfa504552d95674"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e0c8d425fc33ec6519927cd9e7b9e5711dccff110c45eca5acbf899056f00ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45d96100c01aecbaf109aea281a8600beab13a6cf5ad5be6b1a52ca67d64d5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5aecdece54435cdff10b245558a41bd8a98e67d6b775fd11cf5097a1d1042d"
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
