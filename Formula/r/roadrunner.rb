class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.2.tar.gz"
  sha256 "abac9a924e96ebce7f9f39e9497ff14096dd1bb90af2719bfb03997cfd524f4e"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476af85d6ead4459ffef2d738a69af423142bf0c108bafef185b2ced67bd7b0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca917ba8eec16cfebaffe1717e71b2a83542acd9183c76807cef0c4a67697762"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98206a0967c96e79465c69aba3e9389e9f1860c83fac6cb4d57c94d6c1d1e6ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "debe6de2ea633c4607ea7e463de8146ba40a042f587a9ffb1eb96aac9576207b"
    sha256 cellar: :any_skip_relocation, ventura:       "645bfca8b1ca751630c43deabf5b849a84e4b85de81252af76ea7a03d13384f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74c0a62ac10e7bbcfae5fb5fb37a6b9ba4034a99fc9c24cc6bc4fe3d482f323"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
