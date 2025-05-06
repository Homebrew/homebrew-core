class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.1.tar.gz"
  sha256 "f0469f753b5f968254a696e52f7a0fc7e41d806d71fd53e2eda3d2c25697da20"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e29e079c1f8714dbf759ff598db0f888b6547d9faa11b83d995c885f201ee919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab5493ff6e37044e54637b5bb8462b848e6e4585605e49d14a6e5921ac69c10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb4a21273fb432a40498a52f00031df0c46d376f19573835facbd9c832ee1edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af83771144e6080c1003ddfb1ddc5d6dc466691c73bd6f88f4384897a7a352e"
    sha256 cellar: :any_skip_relocation, ventura:       "c84e57d6688d43869620911fdf16a28b0afc1d50628961b2365fbf58f52aa3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb677fa4a4ca97aeed1c124fb56f5680051398c5a027f1729d2dece43290acc"
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
