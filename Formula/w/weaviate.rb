class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "33f277f2e2e09738ba8b247f53e7fca290fb736ca4d3c22d6bd8e2f78c1c89de"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "934506785027664ec9fbf112721733d5cca0bfc1073d1c1ea50c9ed6b2266279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934506785027664ec9fbf112721733d5cca0bfc1073d1c1ea50c9ed6b2266279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934506785027664ec9fbf112721733d5cca0bfc1073d1c1ea50c9ed6b2266279"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a2a1136ae749d343e9930510ea47751cb487f02ad6dc365eb4d77b71ce304b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744f082efe80b3aea5d52f22854dced4f1670dba7a2afc7d7ceb8e10a81ae7f2"
    sha256 cellar: :any,                 x86_64_linux:  "f392c7ac2f7ef905624d4e7c58f42d4b4d12f677a16b213e7550bb128021ba1e"
  end

  depends_on "go" => :build

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
