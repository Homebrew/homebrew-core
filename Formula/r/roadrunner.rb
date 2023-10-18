class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.1.tar.gz"
  sha256 "370b96551ed174d0df27bfdf2933097898c8523cfdf2e99ea37925d61e846e98"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c286e5732b53b423e56cac8246f895ddd37359ec2e903c935c697a7a2b40c21a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c608ff3a768522ea0a4f80fb10fce5d8e7496df77fcafbddeed3dea9e4175a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1c7cf32639de3c3bc4ac281ec7b2e053107df374f3fb9df8b65535f4bf25dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c15dfd61d1bf3cf8b294f9e0b2d26a92e2159f388fbb49e34b967532a983b4f2"
    sha256 cellar: :any_skip_relocation, ventura:        "b5efc72bf95a1707e2609906b2e3a5be0dc829695c56e617fff7c4ebe2ba7f02"
    sha256 cellar: :any_skip_relocation, monterey:       "d7359827af60adfed38514b41bd53dc64b25f14adc279456bfb52de2098c184b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07872b7174aca8232cb46d7ea8aa17ab24cb92557beacff3eba3841dfad03d51"
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
