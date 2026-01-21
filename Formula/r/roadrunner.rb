class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.6.tar.gz"
  sha256 "1c825bce9a6818ace1c5d3b99e8502a826135da54416dcd710575f10ce05535a"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b922ac0ecd0179a39819d0edeaa742f1b30b0d7286328855f29037604aab67d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "472f6a45ee68efd04ce26ca7699a491aa248ae5d7c97e0cb6b316f90322c402f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d3cf7858eda319631a473b9b9e83afa9246cea0f1ceabf483311f4f1c6bd52"
    sha256 cellar: :any_skip_relocation, sonoma:        "19af5af4666d61a0617a1ef23ebdaa0da06867596b34c818d7ab6ab9db277ce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ce21d357fef7dedac29f4ea7ac12f08d65c8bf2d2acead1bd393c707c55776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a39ac075f5765d0af6bc24d9d4ecbea1d080085f26db587109fe84adf980295"
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
