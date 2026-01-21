class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "d10c4abf5bc58eadb72add1629faf5c884f7880bd18b9225249bb6112fd8d286"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c78cfd8abdff9a38e6d3bc9ab657b9566c8d2a570234e9e83944b5cc04960b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c78cfd8abdff9a38e6d3bc9ab657b9566c8d2a570234e9e83944b5cc04960b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79c78cfd8abdff9a38e6d3bc9ab657b9566c8d2a570234e9e83944b5cc04960b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e533273a3c6e5e9e94f44cadba7286888195357336b0f5b8b8b33a4130fd3e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "786f1169e0b0d43d511ed01f7fd94c0057959bc938d61cfe197ecc4adc527f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de3a6f23e8e879446e2d9bf9ad4e2d6b9c68f239c76311d59bcb00fb876ae58"
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
