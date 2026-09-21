class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.5.tar.gz"
  sha256 "77ac8a42813d976d57dd6f36f72b43633902c59324eea8318e6f654d95881815"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d362d06fb10e1dde3e8d9c28c33dbb307dfabbfc201d1b48325e3bfd0b18009"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d362d06fb10e1dde3e8d9c28c33dbb307dfabbfc201d1b48325e3bfd0b18009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d362d06fb10e1dde3e8d9c28c33dbb307dfabbfc201d1b48325e3bfd0b18009"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4772ba4a92b9345560d4b6b4ffc44f3820fdbda8603fb7a88ce33f919854add"
    sha256 cellar: :any,                 x86_64_linux:      "db3b8e02efaac2dc11c0892594c73a075051c8a3146d169b2fe73715a42269e5"
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
