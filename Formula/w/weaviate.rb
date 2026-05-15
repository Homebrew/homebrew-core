class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.4.tar.gz"
  sha256 "018028d0f1ec752f8d6b888365f538908a0606840d7c6bfcfc7b60660663c54e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f7bdf3bc0bd8baabddd69f59724aba7683dd66f35508ca22a64e5f5f431ccf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f7bdf3bc0bd8baabddd69f59724aba7683dd66f35508ca22a64e5f5f431ccf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7bdf3bc0bd8baabddd69f59724aba7683dd66f35508ca22a64e5f5f431ccf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a1c1b5d1771b17881d8f3233ed1487172ca1a0cc0ed4be7b614c5db6388a054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34d8ea74f3a32c065f07373ff85f5e9bd9a48ad442be1516196db7ed074c6545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d05a0e27e052c68ea10c1caf0732b70b562f129d2e7814e5f530ae85c21fb69"
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
