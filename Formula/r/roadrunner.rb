class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.7.tar.gz"
  sha256 "7b5364d26332c893c876deaf69f4fee416702c40480c7f587230b1f648d82fbc"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "547ac2ff940def59061938a943ad6c777a1eca5fbd730ba51b3f9998f68213b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a53ccd09fc090b8489d37ec194e95e7bcf448b6eca46ce7e40fa0dce3112ecf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6d4c48c1a040f9f954346a9c4069146fbd34f08c18fab98b4beeb5edf181cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "158fe80ea40b9378cc8a85d6b333bea1671733f4e3250ffcc60fca61c86c9565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2433f1b08cb23491b79eb8c65a5aa25a209c1cadcceab318db7c156ae1b0b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ae6a4def8c88de95a26e835e6b52254ac95bc07cd2fe70c205c4ee8ee26757"
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
