class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.31.5.tar.gz"
  sha256 "59df48f107e293a2fd1e3081506f8af42d70a43b4a0c48c1be6e9c2f1ac522a0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69c8f7378bbb3de92a72122a68957445dc0408e370f6272752cca862606b976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69c8f7378bbb3de92a72122a68957445dc0408e370f6272752cca862606b976"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f69c8f7378bbb3de92a72122a68957445dc0408e370f6272752cca862606b976"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c9d581819f6769170e51c577117d346557c74948c7ea240ffdee3daecd5ec4"
    sha256 cellar: :any_skip_relocation, ventura:       "a1c9d581819f6769170e51c577117d346557c74948c7ea240ffdee3daecd5ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f7bff620f506cb83dd5a640afcf84a8d37cb6633bf9aedbac33fc0d6f89504"
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
