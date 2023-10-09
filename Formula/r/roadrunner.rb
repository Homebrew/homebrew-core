class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.0.tar.gz"
  sha256 "6d4c4089c41740ca302eef04a84d9d39b8676d7a9b894ba448462eab691ddbcd"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ad3e7bbedaae70aa66ff76cde6fc06489c39072ce699ba85a0c16599572d97a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76f5c2432dcd7a292d5214f5effff6a0652e6038f2dc57e4d5a605108524f702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb238931a0b4caf56e72ba2357a7fd28069a7409d54875f184adb508b0891d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "998041aa72dba8af2414fb330bfad0cc0102cfe104b52447ba6536a5a61f7290"
    sha256 cellar: :any_skip_relocation, ventura:        "6911496ac82993da2d69c2e474570e8a76b730b6a10253dc8e4dae98cc6ede32"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cdd9bd2a5788158892768e7447ba11e0828f6ee1fe95c5cb560ec2dc534e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c34415470d812d55643810b6a657d67f5905d0a290068999fc58613e9dc014"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin/"rr", ldflags: ldflags), "./cmd/rr"

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
