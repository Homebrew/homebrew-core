class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.8.tar.gz"
  sha256 "a31b781908c7499be27e2152e38adfcd2b1bb389a4ca6ca08a872a20a6342291"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4730f8456057653c9c93620f6a8859d8ad146454a0b7f3be0393d5b9c3d99ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4730f8456057653c9c93620f6a8859d8ad146454a0b7f3be0393d5b9c3d99ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4730f8456057653c9c93620f6a8859d8ad146454a0b7f3be0393d5b9c3d99ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f6528a41ade823d2b0d827764ee3c317249e0d599a74c61ed9e7342c2cd1416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca94677b3c5d205371743353e5c96158b9cdb0861c183e4266b014c0b0d1b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8c430bc4ce2cf13e4a4e730ad8be838417acfd4214efc68e85440262441544"
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
