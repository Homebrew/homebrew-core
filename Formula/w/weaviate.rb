class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "707377d8c142fa2b74f661e3bebda77f7e052be6abe3cbd88a5d2b3bb94ded8a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38be1ab9cd95299fe919f2fd6b8773904cacb260425f09b31e3ead6438b9b66b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38be1ab9cd95299fe919f2fd6b8773904cacb260425f09b31e3ead6438b9b66b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38be1ab9cd95299fe919f2fd6b8773904cacb260425f09b31e3ead6438b9b66b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59999cf56ebc4e44e77805d73611e86698c5d398a386a3b890fe2f7bed6baca9"
    sha256 cellar: :any_skip_relocation, ventura:       "59999cf56ebc4e44e77805d73611e86698c5d398a386a3b890fe2f7bed6baca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065dd68219aa5c44393ef4f6a60ab91fcf8659b0abe61a33180f2f5a0c112d93"
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
