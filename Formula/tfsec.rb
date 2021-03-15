class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.8.tar.gz"
  sha256 "04db1519ccf9d3f3ff74dd461b54942775b24024a22aea584c09aff383d88b47"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ab0ebb7f4e23abf44eb5ff2d7c02f68c1eef62d836c31e064e34a12fd8b399b"
    sha256 cellar: :any_skip_relocation, big_sur:       "98795faf9c7dc9abe2c1271b793323b8cbfbc20f41a64974e9fd58931d54ac4a"
    sha256 cellar: :any_skip_relocation, catalina:      "81e0742bac3a24c156b27556b5697ddaa81775c3716a661c1e6db11aa7b02865"
    sha256 cellar: :any_skip_relocation, mojave:        "5f760aa0302cf3152451645e78e05b54b86cebfe59c50fbce20d3ade5de7f6d5"
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
