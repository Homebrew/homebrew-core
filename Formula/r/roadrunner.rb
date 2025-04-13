class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.3.5.tar.gz"
  sha256 "77feb394b0ca622b18bc2933edb275c6f4b7e9effc04926e6d1ad2949780da50"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eefe71aa1e1e9cb27f03fb1f611ae9411f5de61b7c7bfe73dbd87b00ab4ab22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21265b160615a6be853cfab951e603ab794615a0acfef0db2c72ef625591aff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68f43967b7ffc02876027dd4f754c0735d7a45951168cc03bf529b33acad332e"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ac757affaa39e3cb9cd44760ce6bea40133a73800f36ca01e454e4a417b152"
    sha256 cellar: :any_skip_relocation, ventura:       "ccfb7efd66f58ee253a29effa8462e5af8fbd34dd8f1727c3757291f002c5304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a303e32d5f7d9b59bcb2fe0d0836d5b4d91d9ce124f05f0a821a61af56b8850"
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
