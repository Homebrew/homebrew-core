class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.0.tar.gz"
  sha256 "47fd204b874f6391a4279fd30f1a13aacb9ae656d8166ce582783938f618cc84"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfe4b7f8497af468aadc0631a3198a53da84b6a3f9eb19b6b42ddf45a57b7c56"
    sha256 cellar: :any_skip_relocation, big_sur:       "4276ff3c226c45ae4c7979e322a0c7fe988a1d6cabbf02d0488a04632f7bd363"
    sha256 cellar: :any_skip_relocation, catalina:      "0ddb88a81edf940fc5cdf9622d29bca10bdb96d203429a63ec25a80c15b01e44"
    sha256 cellar: :any_skip_relocation, mojave:        "fb222dbc67520d51a49f4c88ee5e12945d50f95c47848867f57cb8619c85e773"
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
