class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.36.tar.gz"
  sha256 "44f068eb490c48b1c14f4d15d3a5a56dcc6fc4e759a892a49a596fedfaf3f46d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5dbfa03a22d23030cab15745035f3bf98788619a85180589c47ab5816b5c10c"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1bae578a7d825c0e5fc60e862145257034f1b085fd05fde658a0f61fe8b3fad"
    sha256 cellar: :any_skip_relocation, catalina:      "dc1622fd271db7fccd82db24d3823953805272f16d3dc1f5d80778af1f03cd92"
    sha256 cellar: :any_skip_relocation, mojave:        "dd7eca55e43b31bc9f5fa20b5aae547492904feaa810277ddbb152cdd0ac076a"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    refute_match("WARNING", good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
