class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "39530fdd936d083bbffb54ca8daa87d0541392fd9bd51c4a4cf9919d2b247697"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfe50cd6ec91bc4df94617b021ad8649ccea470472fca0103277a995833463f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe50cd6ec91bc4df94617b021ad8649ccea470472fca0103277a995833463f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfe50cd6ec91bc4df94617b021ad8649ccea470472fca0103277a995833463f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "40c6e20d745a81b1ad1567bda5d48e88f51d677f57354396ac5f1caf5619cc88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e19db9540d41dde1fedfc81f0869adcb56b56ffca664364c41767497fe2a560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "755b25994205b2d1df644b8547e84b9e0cf4b046ccf7b0725ad156b9a4b3718c"
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
