class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.5.tar.gz"
  sha256 "9bad9ed754d3b556ebedf9fe5244c63efd9e66d504b9ece1631bc540d0a46399"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e400791551cddbb514a98360551d6d7a826ae7b15e51dc0845c72cb6ea8d62cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e400791551cddbb514a98360551d6d7a826ae7b15e51dc0845c72cb6ea8d62cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e400791551cddbb514a98360551d6d7a826ae7b15e51dc0845c72cb6ea8d62cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8960437709eab643175a24ace1dd3e5066ea807a42490ffe95bc6a08eb7808b"
    sha256 cellar: :any,                 x86_64_linux:      "5eff1c5d41c5e4bae7a1486448bc7ab125df4b21e144c0f855813fff334bebcb"
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
