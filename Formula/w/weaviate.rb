class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.6.tar.gz"
  sha256 "5ce653fdd2b684fb250ec32b724719ec9dc72718d00f85483a3ae98969153cdc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "519e1df1f1d682d99472752acf4e4876a2efedb3bdc0b8088c02e3dc3451fab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "519e1df1f1d682d99472752acf4e4876a2efedb3bdc0b8088c02e3dc3451fab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "519e1df1f1d682d99472752acf4e4876a2efedb3bdc0b8088c02e3dc3451fab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb756fbe1e77ba3546c42e2981a77cc6f1835dddc2988fbcad19263b4fd4fbb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a1e5226cabe053f0f5069586627dc0da736007936291beb24e5bddecb4660de"
    sha256 cellar: :any,                 x86_64_linux:  "0a6a7417afb9099ebfc694715e1e5da4b5636218ee3d709cf52acf86a12a4bf0"
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
