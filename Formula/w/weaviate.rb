class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.6.tar.gz"
  sha256 "c0fa89bf0c785b66beda66a42cf2993c9d27736dce98fb7c6dcfd0cff6ab8994"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3584dc7f0d16cd9e21f927148492cb3126c3fd8054dfd34b6738e1636fc77af7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3584dc7f0d16cd9e21f927148492cb3126c3fd8054dfd34b6738e1636fc77af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3584dc7f0d16cd9e21f927148492cb3126c3fd8054dfd34b6738e1636fc77af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd984e1cb133bf0fbe189b8e84f6e58ad94604d8f3dbc68c02e5e2d6e6183778"
    sha256 cellar: :any,                 x86_64_linux:      "690c0d16904112d4fb34b8f4e9bf880b07fae1eff12201184782827ca7d26812"
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
