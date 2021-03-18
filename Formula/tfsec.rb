class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.10.tar.gz"
  sha256 "a8da522156d1d644687e277672b8a675ea35a66a4689092cd45b85bb6ac0b21f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b53dbc6927d0d3bd51e668b83fe7b97288b763acd091e29205294614a8a2c94a"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cb29b3bb86887ed3e1597279445a1867adcb681923e6d6409f89ac0bfbf6428"
    sha256 cellar: :any_skip_relocation, catalina:      "fa51eba1fdb6be5b7630b075898516e9e832c4d82741d19dc33a0a980b51d1a7"
    sha256 cellar: :any_skip_relocation, mojave:        "ff4e7653c3111d6f597e7c8c734f3d9b8c8963cd545de100165f02d06b994c6b"
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
