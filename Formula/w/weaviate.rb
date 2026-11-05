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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "082daec32f43c4895bcbc593e2609ba09007a272338fcaf328314bff82c6875e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "082daec32f43c4895bcbc593e2609ba09007a272338fcaf328314bff82c6875e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "082daec32f43c4895bcbc593e2609ba09007a272338fcaf328314bff82c6875e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b53a3707c99619269956dd454850dfbe7a7ed07dc8813d7c4f4a8a041ad1d15f"
    sha256 cellar: :any,                 x86_64_linux:      "dac3820a1292f09097fea6a5aaf9a015a80e37022c1c50a38311e02560619031"
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
