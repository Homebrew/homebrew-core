class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.12.tar.gz"
  sha256 "e74c7fcf0fc65e06d0640b9939d881e32f84af660e0204a6557dfbc648eadd2a"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd25fd88df1db9fd18880e50bd6a002d9f4819ec6ea58926e8b5d811e8193bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2e2ecb4f7cc5e4b766bfab7c92bbbf647afadfb36c7bf69dbcf0136f4b6d393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6518aaddbdc7a911798794013b58f44c4366b3816f35c999007360f137355549"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ad015227c84485fd4c61c7d8328410be0dd00b69d2b57a8c6e787e657fc7db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c319dbb90655ce2cdf92aa30fe6d389bb9ccc0de221d92645a738064ac796657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34244543a4e4eef55eebaa904a5257b6a23026cecfed6c42cbcaaddac3d199b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "aws", output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
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
