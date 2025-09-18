class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.9.tar.gz"
  sha256 "4da1d801bc48a6d1e2d8aa05a7015f57e025347ef0745ef9ea026da35892a37c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "722d673f1e3902dded28d17318625bf601ec1eb9b4dabd3e01bc1ed1160a7f80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722d673f1e3902dded28d17318625bf601ec1eb9b4dabd3e01bc1ed1160a7f80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "722d673f1e3902dded28d17318625bf601ec1eb9b4dabd3e01bc1ed1160a7f80"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1da2338e4aa3431df13f0176cb1ddc62b06d61ac2592b426bb1fa8d32152d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3938c5f0f7364e710e04d653e6b188f8859f01083a47111d8b3f5d9a8de3caa8"
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
