class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.1.0.tar.gz"
  sha256 "21a9c20b3bebe94be7a8fcbd87ecd7b6e52e838cf9cc6476e881de61a4b5a00c"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c9f04d9d7b4c051eb23238899dc812d3f915925b8a7c48718c0fc342c8a5ef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a0868dcb652ac571d8a60bf7d7e95b9b8b66c9cea8dc48e9ec96c8482e5377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef550bffe3143ddbd4fd4ba2d4aaaf4f8ded135c17c09919beb4d747d9739a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9f1b0e30a9bfefe17b5460fc2c1951cd9fb58b23201b9541645c93a20ac50d5"
    sha256 cellar: :any_skip_relocation, ventura:        "b51e046483b25187045a5580d13e4d922766d1f59818027dd371eedd9fa5aad3"
    sha256 cellar: :any_skip_relocation, monterey:       "edcbd8bcb4142c07b85c1a0767c2bada7b95d6f8bb49445787ec467f6e1462af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9a4539c11eb83b92b476a63afd624ba142bd2d4081f4faf9d2f8c18d7fd909"
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
