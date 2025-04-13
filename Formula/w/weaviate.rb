class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "31310215ef9c41a74f74e32f340f38c5f5dcf4a74c60176f612895ce5fc4cda0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a306c7c3b9afb86c6e42e938b53e0c1f4d60f4663e15c798399ac538dec2469a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a306c7c3b9afb86c6e42e938b53e0c1f4d60f4663e15c798399ac538dec2469a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a306c7c3b9afb86c6e42e938b53e0c1f4d60f4663e15c798399ac538dec2469a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79267fa605314962e744124d163ae7a80578797cdfd8a773d8ff7cbd0922214"
    sha256 cellar: :any_skip_relocation, ventura:       "a79267fa605314962e744124d163ae7a80578797cdfd8a773d8ff7cbd0922214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec813db651c9c487e90e3498deb10387247154965f05f5dbb2dc7e5756fe2eeb"
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
