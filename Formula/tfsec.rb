class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.6.tar.gz"
  sha256 "c8e56f367b9978914693db7ca4dec684af2e87660191fde628486322b11b4c3a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f817b009c29968dc3ef178ef209c8171f3106aecb16f882dbdbedc8319c46a01"
    sha256 cellar: :any_skip_relocation, big_sur:       "138e28b96a8315e41e836718d4d16228adf7333b453178b91de6be87428a0ff6"
    sha256 cellar: :any_skip_relocation, catalina:      "e4b96246bfd7966f9aae7a333e430eb71a2ad9fe8b9eba209f18e46aecf3f426"
    sha256 cellar: :any_skip_relocation, mojave:        "cd38840831c6f9a5b3067c0e6f117aa051f2644655302cc49f9796a0afc10401"
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
