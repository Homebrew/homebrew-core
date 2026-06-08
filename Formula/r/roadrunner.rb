class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2025.1.14.tar.gz"
  sha256 "2ec7485b935f3e22cd06bc96abc7db34f83d098e457275223e5c615cb0ab425f"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "063e0580ee04b9326c0d04ba4e3977e864f1658ec03e52cccea42bfd42383760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef04c74ef5c858373580473a5ca41cd154a42eea27e5293e4aa5ed7cf565c380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221a57e2f05297fa916d5e045c13c705f5821c0f961c3f971050aceb856b1dac"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c45fdc7564e53d721d885f18fbb46f5d17e37bf6425c83b43416998b145be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c72653e81615651e37843c3b0e91a61b3c73ee11d9b2a716670e8d8cc0dad2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0adcd6ad3a77e4c3f7b1800578ab396a8750994c321e18c73b9425241b4e0968"
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
