class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "cef4675e04b3983f7b44912175bf3e5c92cd306dc2546a6795128d77455d5a58"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6123121b556943b195de169b1248b52f804be1e6709d1b0a8e6259b3e41cc0ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6123121b556943b195de169b1248b52f804be1e6709d1b0a8e6259b3e41cc0ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6123121b556943b195de169b1248b52f804be1e6709d1b0a8e6259b3e41cc0ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f1ef6e0e515e6c423fc1f74c53bde4bdb3c586fa581a8ebdd636d83efcfb951"
    sha256 cellar: :any_skip_relocation, ventura:       "2f1ef6e0e515e6c423fc1f74c53bde4bdb3c586fa581a8ebdd636d83efcfb951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff9a795926851c674a9aecc2e921eaca4ccf10231344cad36a7715dc7b343397"
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
