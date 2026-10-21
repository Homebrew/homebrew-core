class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "4a5647cdfba543fe04347ba7658a65866508ba50463023750a36a1d900bedd36"
  license "MIT"
  version_scheme 1
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{1,3}(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d98a719f45bb072470986638a77719b79da37ad51ae155cce9f03fb4a76c6a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da770c576d1102417e00f841f0f46dfa5772b1298ee29d371fd680199a0037d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6659f34afd3e48431f3577c0933cf497383da4cc05f96fdaf02783a477c7009e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e9154c1a8ee4d5f94b5a22ba919b6d9c4e1ab09ddff34ad2322de2e558eea42"
    sha256 cellar: :any,                 x86_64_linux:      "0d43f174a9b3104e56e5cd9946f6f9c32d1dc4a533ea3db0f1d31bdd8aaac0ee"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

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
