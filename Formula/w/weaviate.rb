class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "63c108f895a9bb999759680294dacabef78b6bf0b066416c7bee4c9bbdd98b6a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "0d25cccacc4a614ac5c7fcf7642e057758ef38d515b20a4af8a52878bcd982bc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee77eb855ba3d58766cfe675424c373a4b70dd8bf8e75c9eaa2f56de6f14c4d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee77eb855ba3d58766cfe675424c373a4b70dd8bf8e75c9eaa2f56de6f14c4d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee77eb855ba3d58766cfe675424c373a4b70dd8bf8e75c9eaa2f56de6f14c4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fb17a7438bba393f117d3d8a605f139cb3de15ef6259bf0f5ba2a89b8542328"
    sha256 cellar: :any,                 x86_64_linux:      "0daf50eb4bf49f52235ef5f3871f3853026194e0334e18240a8d76152c3613b1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
