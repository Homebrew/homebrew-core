class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.2.0.tar.gz"
  sha256 "b61dd97459b7d4bb88b6bd7e37552b5e84795442024fd78725ee1b3cc1bf887c"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31fa4f816d9f762d22e259ae23c002b8b19d081a82f27032fac920e72e37ecca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06ee92483744ed1adb5c3a499fdffd1871185f0551230f7fd09eee72bfb09dcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "649ecbd926962bf15929127de9730ce5f292f9e09e7fcef25cd23b4e54f4a0b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "19caf60fba872795fbde1dc0c55af61d8af7c6eba0c96d80af2c827c14dedc06"
    sha256 cellar: :any_skip_relocation, ventura:        "bf449a936e21ee37d97d2a1cfac0a28cde0d7e56fb6439624f3fd4faabfc87df"
    sha256 cellar: :any_skip_relocation, monterey:       "87e819f2e9864f42c1c1cc9dece18916300d663d509f300ead6be797574a4841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b2a977676cfaa2a824bcbc9dbffaa8d088d5fba648c563584cfaf035480c7e"
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
