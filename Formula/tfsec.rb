class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.14.tar.gz"
  sha256 "d5da5b9bde8eb7721169224e95fc6be68a8348f17cf9b9a7ee77a338ef516544"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2bab5496f974615f7575640059065dc21a4be235878187f73822a6bd26b78d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3e05237d459f7f72c4302a2bdb0b7d1ce2345aaa3cbbefe8d0c62530d970243"
    sha256 cellar: :any_skip_relocation, catalina:      "830190ede966118c8496b5e02bf7962ee0372d361050dcc3dc4593aa882e022e"
    sha256 cellar: :any_skip_relocation, mojave:        "0430418608448b7f8d48edaee332389c25ae69b3260172154b37edd05340b800"
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
