class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "38cc487db8b86a1c811701f99c5932f0c695c979743eb7f9c000699c5f64fc23"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bbacac59d0405a0b96211ae5e9ae299356cd9c58700248c944be8eade0aac3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bbacac59d0405a0b96211ae5e9ae299356cd9c58700248c944be8eade0aac3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bbacac59d0405a0b96211ae5e9ae299356cd9c58700248c944be8eade0aac3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b971cd5db3e4948ad5765e67260a6fcf610b31b2fbfa8a508833f3cc20738fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e940ef7599afaf1ef2ea3c7497ce42baf936c31148d2d367cfb94ca53f363a7f"
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
