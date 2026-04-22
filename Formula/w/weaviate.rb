class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "0d0ef0c79fb9f5f83e99cd1644dfefa94b2ee5e124f6c66547aaf5e3941bfc26"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e6d6230cde73e2dd0b9f184e9be96123abc4b959ceb518eb2a48728334a6098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e6d6230cde73e2dd0b9f184e9be96123abc4b959ceb518eb2a48728334a6098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e6d6230cde73e2dd0b9f184e9be96123abc4b959ceb518eb2a48728334a6098"
    sha256 cellar: :any_skip_relocation, sonoma:        "d12d65bfdc4111cb79a033fd05fd83a6988b013fad74e638a13d0119d3298794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ab1d453021c306c5ebe91cacaa335443eed8e38cb6452d0d87876d4be873ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016d8fb769ef85e736b7e192962247b0263781875d68ca6232983efa6cb394ba"
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
