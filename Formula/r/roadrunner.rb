class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.4.tar.gz"
  sha256 "02e9585c6bc5557440ca92ba1fcd7910660dcbffc76d0c8f13e75497ac4134a1"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "183ae2a8b57c751d44c1a8c058f0a9d796e6c054657416472c1c7c06694520ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5936e8b972a6b37100ecf72da3937eba7fa050791b1a8db3e6dbfa427f9d2270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e410178ecc56d69b8a33146c49810a2cad8b9527ba504849dedd3f7033e72f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e6f496d4752d3f91fce14d547526bc63a787bc42e309e5d2fdbadec5393ef0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a27016fb1a24e063426eef504e79fa9c96ab0e60f67386242e57536b0da55f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c021a1bc77b1b25f5ebfe1d38f0fe8819e49c79c52dbc930c338cf19ecccdf6d"
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
