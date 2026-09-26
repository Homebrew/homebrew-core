class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.7.tar.gz"
  sha256 "301734f751cbc85664fd9500a24804916d2b7b46d40f1b9d20f8f953ea94abc9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95fb15eab7dc72d0df97fd465618d00df7232e0028a9e9de4d8de322c7dd87fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95fb15eab7dc72d0df97fd465618d00df7232e0028a9e9de4d8de322c7dd87fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95fb15eab7dc72d0df97fd465618d00df7232e0028a9e9de4d8de322c7dd87fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "678999d81e31db1e36941bf19d646aa0a513752188007c135f6c24ce655f706a"
    sha256 cellar: :any,                 x86_64_linux:      "63f9c5bab7a05090dbfe02d2e52662bcf4a8a2466b5508bea9619e281169dbe0"
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
