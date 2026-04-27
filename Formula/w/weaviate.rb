class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "067f55e91e10b0ab6dfde8710caf9c09dcea5bdec0344ab0d20bf0887ac6f8d7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5461dc578e1acd4069311382377dbc49d7b1caad0b16f73313de98b1a782df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5461dc578e1acd4069311382377dbc49d7b1caad0b16f73313de98b1a782df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5461dc578e1acd4069311382377dbc49d7b1caad0b16f73313de98b1a782df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca32ae05912d7bf96d9b840b8daf42f834343289d96595657a5eb6638a0bf4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19874f46d654ae4fdd49ff596dfde3ccfc65156ef17e58f6ff35563af24371d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3464c2cfa9e3c4f0adfc66f24ce4ccf9d7e533e81314b1b28a06d132dcbcf73"
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
