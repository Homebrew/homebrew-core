class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.4.tar.gz"
  sha256 "97d7135c6aed9ccdbc0880c6e0e02dacb0541dec2f147d2137beaf1fcb77a2b2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f3a09351b72eff548b5e37b62675fc7622dd6fe0d0085311cd11054f5369bb3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "61512db3d21ff29b54f7d2de7f997f517de27c64e5b7ebb6e06b83140e996797"
    sha256 cellar: :any_skip_relocation, catalina:      "8eee5afa9733e6115ec1288850acdd233e77ebc3dd2676227505db225b477f25"
    sha256 cellar: :any_skip_relocation, mojave:        "f2a057e0e500aa427156dda398acd091eb34dde1fcb9dd3f9a9d468981119410"
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
    assert_no_match(/WARNING/, good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
