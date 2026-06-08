class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "b1f6bf9513ed4a7cafe8238a00a0420a33a78ded904f24bac26f20810b749c4f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aef8ab0eca365d688a1c081cf3fb856013b20d29ef4aaae584a783794f4fc3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aef8ab0eca365d688a1c081cf3fb856013b20d29ef4aaae584a783794f4fc3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aef8ab0eca365d688a1c081cf3fb856013b20d29ef4aaae584a783794f4fc3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a9e1194fb9b28ebd9dc815eb021b89b578b6875e84c74bf045ab481160d4e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f049acab2c61278b0c63242002aa871b1fe49ebdbfc0eca0a3adbadedf77f9b"
    sha256 cellar: :any,                 x86_64_linux:  "485e1e6a39c182a5a209ce2e8ffa68a407c742bfbf0de4f19b82762ff662508f"
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
