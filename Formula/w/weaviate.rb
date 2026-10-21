class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "1cd1594a15e0dcbfc86aef82087b3261eadd90124f0c8994e5420dd4fffb8b91"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fd3ed9a1aaf0cc06a188b18a714a02017f5857bc1d9920f84d5da4856108e84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fd3ed9a1aaf0cc06a188b18a714a02017f5857bc1d9920f84d5da4856108e84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fd3ed9a1aaf0cc06a188b18a714a02017f5857bc1d9920f84d5da4856108e84"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "acd0de5c77a8957c752c412e60a28af3d0685f203cd0c3b701e312c36882abfa"
    sha256 cellar: :any,                 x86_64_linux:      "5984b4c9ab0e11d9d7bccdb5eef6a846f9a3173f0771495975972d20fff63038"
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
