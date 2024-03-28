class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.12.tar.gz"
  sha256 "608b30987a7c56c1089474782a7dee6c031f2529319b7952ab5f4074b5018fe0"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d8eff5d9d59035454415df3f3242bd260f4904bcbdf02c8deee65acde9a1d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7749902908eb3338390523c908db1160810291c4834209fc3c6157f1b7c8a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aa3b409253ff9c1a51403a1ba75ac0ef2c9f4d53e079450f2f20841adefcbe8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bc06ba7bfa06fbc1ec269ef211356e25fd4b129af1ddca70e49bd9c99f19fe0"
    sha256 cellar: :any_skip_relocation, ventura:        "f2eb0010833f9342803271882afab378eed969034bb9fb59a134a3fd4434ebbc"
    sha256 cellar: :any_skip_relocation, monterey:       "d98c8ee66b095ae0764b418f74052f61cd83f6e3d01725e1539870214e7019e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09baff769899087850245f9c8ec57b8cb65da94e782733fd233d1340b7214f1a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin/"rr", ldflags:), "./cmd/rr"

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
