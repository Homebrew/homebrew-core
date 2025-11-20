class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.5.tar.gz"
  sha256 "3819ceeec4e4d1f629868cad458ad4e6c0f70bb95a169ed40901d94b67f85501"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b441112f0e978911d6df2a98a6eab4a9767eddae9752b4e472511a94f511c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d52e5d2da61b7301e8c3d5f5dbee28bdb576990792bf37caad5a8d5187e52d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc6252ea411ce8dde2a22a45daceb3437909b801b70d32d30ab9d92bb977bf16"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5becc6ef7a42628748cda045b66d21c55b6be57a745354c44c1d236030db458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a258920b986d5647b370be5639ba82a4db72b7b4743b6fdaba5735695d5609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e074d0b31457ddaf826196790b1c49c700c1c52fab7b285cb2b69a0771f780e"
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
