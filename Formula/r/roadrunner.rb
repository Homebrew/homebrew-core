class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.1.4.tar.gz"
  sha256 "bc8fa02e22b1e012d58b6575cfaa6755d99aa2f1a7035aad89411010a5830d2f"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9647d340785e7dbb8973e68525d3d90297e2e38141e17c01b540c8afbdc92d49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4487ce8bdc8deea27a9dc2bef51e55aec9c072f3699c043c37d1989971e6da3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6493f517f885957ff613c31db4688a1f1b3d32563cadafaa8ac05fd0e7db177"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cddcb0ead08a46524d07607285a5a08c92a4448c87aaf26ea58292a565f15e4"
    sha256 cellar: :any_skip_relocation, ventura:        "b8ea3a772f3dea8654b7fc89169cf23067497969d7d24d3597a2e1562d075d60"
    sha256 cellar: :any_skip_relocation, monterey:       "450ad9916afecadbf9c96b509e61b845d2a26fe8f5984fe7498e9340fd22d664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d04b7b6cffdbe28dd59227cb2e3656d51d78b48998139d905ea81fe810d4858"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
