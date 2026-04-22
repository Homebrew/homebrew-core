class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.13.tar.gz"
  sha256 "10745d59209226a1d4c92dc9409e405a2846bf0f3517d1f4bd511562f9793aaa"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e7d9961503c4bb0cde0ae57754bba252e7e40a939a5630db7d4ed6e6e8c9e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7e20e2ffaa5b808412a8011a7e9f08fba033ece6b5555631421cd0a1f38a2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fecaca4dc526870c80fee2f18a06d6c024be2546362459bc2acde7c66a5f0706"
    sha256 cellar: :any_skip_relocation, sonoma:        "547930db3c25af17c4b068d1e43d09d11a91341756a9022af858fb391d662ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f7160e234dfebe451c79f7540cf23f9ee4a989e2c9ac8d49c75b8843973806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a7c904d8e2e3b43cd4ea9003c4f56b13dce0b21acf6221188b3309f25eac96"
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
