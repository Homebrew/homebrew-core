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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f602a5388fa8ca3f6dc26d3173ffb822e7225d9dc6f1184844721f4fa5a8614"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d2815c521bec124b74c200b13ce8fc822c1db28cd81f68f4564f422f63d9c5d"
    sha256 cellar: :any_skip_relocation, catalina:      "66ff8e504eaafd1f0bae22b2832f9b63990921187579d59780cbcd08e46e1efc"
    sha256 cellar: :any_skip_relocation, mojave:        "fbceb608c9682ac965d5d3c0641fc409970f46c8bc1b3bac4b863518a25793a1"
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
