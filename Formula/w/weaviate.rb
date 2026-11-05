class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.4.tar.gz"
  sha256 "a3d437830e57592008e43a3d0a278ca853f899f5403bc3417c4a784936939ff4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8bc5a58e6ce786cd95760122347ecd6e1405d488988f35112731315a2cbd905"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8bc5a58e6ce786cd95760122347ecd6e1405d488988f35112731315a2cbd905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8bc5a58e6ce786cd95760122347ecd6e1405d488988f35112731315a2cbd905"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b543886a25cfedd833554fbef332da92415f94ba476ebd5d5cef6ddcadbacf1"
    sha256 cellar: :any,                 x86_64_linux:      "e56ad0090b607094161889f2f4e373444c695322719125984296e450c45adc43"
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
