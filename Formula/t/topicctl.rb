class Topicctl < Formula
  desc "Declarative Kafka topic management"
  homepage "https://github.com/segmentio/topicctl"
  url "https://github.com/segmentio/topicctl/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "fb97094222529c018917a0ac29cfd139b6991a168634eb067f7eb4b26b8424b5"
  license "MIT"
  head "https://github.com/segmentio/topicctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0f833e3ff25e07ca3d19276f3ab81af1510ea96b000f3245904a7ba8eb48471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f833e3ff25e07ca3d19276f3ab81af1510ea96b000f3245904a7ba8eb48471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f833e3ff25e07ca3d19276f3ab81af1510ea96b000f3245904a7ba8eb48471"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17132aaaf3c3cfb8e9e90b9daa34622d53af4a6545cce47a4c28a71a7bac4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ce8ff37b015a67bef328e2fa8eb62344d526a2c7b3559126025d642ed6812e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bef3b8fa1cf53ef4e87016c5e475649eb67430985b36657be306a6b5e4780f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/topicctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/topicctl --version")

    (testpath/"cluster.yaml").write <<~YAML
      meta:
        name: test-cluster
        environment: test-env
        region: test-region

      spec:
        bootstrapAddrs:
          - bootstrap-addr:9092
        zkAddrs:
          - zk-addr:2181
        zkPrefix: /test-cluster-id
        zkLockPath: /topicctl/locks
    YAML

    (testpath/"topics").mkpath
    (testpath/"topics/topic-test.yaml").write <<~YAML
      meta:
        name: topic-test
        cluster: test-cluster
        environment: test-env
        region: test-region

      spec:
        partitions: 9
        replicationFactor: 2
        retentionMinutes: 100
        placement:
          strategy: in-rack
        settings:
          cleanup.policy: compact
    YAML

    system bin/"topicctl", "check", "--validate-only", testpath/"topics/topic-test.yaml"
  end
end
