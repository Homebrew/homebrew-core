class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.25.tar.gz"
  sha256 "1df4ddaa8ebc57d1e6c10da62d26b60969a52f6bbe9bd8969ef37619bc34e832"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99b4ba1885e623ad0fdfa5ddc25ee8db661ebd3524d8e0ab6b09be573cadeb84"
    sha256 cellar: :any_skip_relocation, big_sur:       "b51797069b077340a544fb555af8a4369f99031bfac761efa3a54afd358a7a5d"
    sha256 cellar: :any_skip_relocation, catalina:      "7971eab54f280a28a2c8fe754a6c2bd05d67c597ead22d2c044fdad2fd23069d"
    sha256 cellar: :any_skip_relocation, mojave:        "56d479cefe8f4edff5cca6ed6e610c4411f3f0ded7c273fa6c4345cc863bf954"
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
