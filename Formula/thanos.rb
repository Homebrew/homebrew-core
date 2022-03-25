class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.25.2.tar.gz"
  sha256 "c77fe0ec6ce596506fd200548ec90dafe0bd268cdf0e0fb965a2ff2648b18e03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e477866cec3064e692edd3dc3ecc96ba280df27ab9c3ac750c5d41698d354c9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "864ebb003168b33d8fcac4a07c232b2a2a4f0caf948dc729c9e6492a332657fc"
    sha256 cellar: :any_skip_relocation, monterey:       "e70a6f9def36c694b9afcd71ea44b699802d27b73009eaf8be55edcb1f3015b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9b21c438a2d0f840a7d3e2321a2cfb8c6ea6ec2bd4d336cdc2f3e75d98b641"
    sha256 cellar: :any_skip_relocation, catalina:       "7c66dcb961f9234db61b4a40b2e018d22495324c4f3e3f838614cb9b4aba4629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "056e263d63376f1e86239c754e962d73f9eb35283e1dc02218bfd2605e242f01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
