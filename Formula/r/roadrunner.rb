class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.3.tar.gz"
  sha256 "d9deb39e441b21276172062572b0f3602b89915a8fc54ab6e9874ee581adcafc"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7134c9ec5dd1db9b34b4847c1ba98eb7609589a89caa86db28944be90da25e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c39e10da4d66a4c807fd57e17dfcba1bfb2d2d74354bc958af22194a530a8d12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f98063565155023e7cdef1e4c49fa1acfd7df482ae39f22bf20e0318ae20225"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b97be4da2d70ac6a93b5bd37154b4f3075c41351aa5f35c859ee7440f9321dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "86e3f60178ef2bf4547b4a171922967be95f7f8ed38050c0c1d55ab1668be3bc"
    sha256 cellar: :any_skip_relocation, ventura:       "ad5df2a9dd164800e1d47afd331a4e15ae7c30cbffff16ee5f1f69d5a804aaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1f508c387834c660ac75383fef1e2338165c82f0f4bef529cbc79493bbe109"
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
