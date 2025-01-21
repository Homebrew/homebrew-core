class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.3.2.tar.gz"
  sha256 "6cbe13f281ab6209458f5e600d5cc68a7cb908e6c8fe90f65dd5726338df8e3c"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11db5f950625e6174a08b23bcfd61d27d7903a48207cba47776111fad6c54283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d5df614983203080930878b1fdafc1f670bdec70d3de7b1c75c56058ef34c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb5e1360ff5c0b63ad8d10124914fe649fb43c20fc056adf7237adaf252d9748"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c033b583b47f159b7193df02051b42974c1e4c6a0b1fe901a98165956639c5"
    sha256 cellar: :any_skip_relocation, ventura:       "9072ca4cde654fcb40cc8e0b335a4029519e9c0a1ce518750c5f11ec2b043a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710156dd8dfbdffcb3db61b382e2aa4761b77d017ea46860910ddf8f0ba3936c"
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
