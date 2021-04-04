class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.19.tar.gz"
  sha256 "71aadb33c3a6822fb6590da5ae0d6c240065a290a18ce0c7ec1a66571fdabead"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "faea13f6788fa43acb4a0aaf57cfc4ccacd03823e20696621141ccd146841671"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf6d462eda4bc012a0631820d664c1bed5e82efdac10e4110c7e52ddc6f5ccee"
    sha256 cellar: :any_skip_relocation, catalina:      "9a82bd022ed8fafd0aa4ebf4930c5aedce8f9ae8d3dc72a8b77eb090f8acbf15"
    sha256 cellar: :any_skip_relocation, mojave:        "2002656ba435a8649b06355e2b456a71fb5c2e27a3541b05f71c7138ce950df4"
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
