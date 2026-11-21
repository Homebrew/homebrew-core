class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.7.tar.gz"
  sha256 "87baaa307608bb665645e7f553db47f423b760c4b118f91684bca358c5a4f820"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cfcbc9320bc57b9c0121cf6e119189f34cd433b03619c0de3e0b330fbb67534"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cfcbc9320bc57b9c0121cf6e119189f34cd433b03619c0de3e0b330fbb67534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cfcbc9320bc57b9c0121cf6e119189f34cd433b03619c0de3e0b330fbb67534"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f3db35780af10fbe5069e7e0daebc918e9a49a3daaea4c49d7770a8ede1cfa4"
    sha256 cellar: :any,                 x86_64_linux:      "33b0420a934beffdad8f10f76d79697790fce48c669f632af314d81c105838fa"
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
