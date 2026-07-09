class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "5293b72f7cb1a3dba0e30ac1863f4c4ab7234472f46ee3abfa8af0e78e9e3c9a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8952132c49ba618ed5bcc4b3c017a5fe7a8d375729330d263fefe89e7803f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8952132c49ba618ed5bcc4b3c017a5fe7a8d375729330d263fefe89e7803f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8952132c49ba618ed5bcc4b3c017a5fe7a8d375729330d263fefe89e7803f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7f1ef97dbff50b34acc2b443b355f27723fc957c38483c4f2b8accb67112bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "128d3ffe54495fc79741848f7e6017bda24e51ec255389cfffdc497a28bcee75"
    sha256 cellar: :any,                 x86_64_linux:  "3ad2684e7ac2cfe62c04a7583755ede4ca5f312302057c03a2c4639786071c23"
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
