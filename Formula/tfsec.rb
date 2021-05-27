class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.42.tar.gz"
  sha256 "838b5ebd69e2046d3bd06f87915ce30ef25fe469da5d27b2f9ff519c0cb0d719"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47011dca657c2239ea422fbfe5b3b66f457366ca6e581874683847d324fd67d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce37f7ab2a6dade3839c5d769be6517b7d60d93e0f988e9644fa9e8afc0bc480"
    sha256 cellar: :any_skip_relocation, catalina:      "96c12afdff3f4c3493d4f883c7de67c542d2e03ee058a96e05b5024869f6715e"
    sha256 cellar: :any_skip_relocation, mojave:        "b8606519350fcae8cc568862cd23cbc3982211492a1da13b7e6587fd2fbd69a2"
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
