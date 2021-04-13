class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.21.tar.gz"
  sha256 "2f3dcf40e65079e55f125e7f8f6cc94565469f34c27d77d0b460beb4ade3e644"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31d0aa8f96ae1ec89374835712f3ef4a6a1997c8710e0c7f51892d3f36ef2212"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd84dbb158906732d2ed96cae8de23b98573ff606cc36806a0ef009110b861af"
    sha256 cellar: :any_skip_relocation, catalina:      "96cd245db4c943fd79e65bfec59316fc2ea08d10675a04a24c234c4027ee52c4"
    sha256 cellar: :any_skip_relocation, mojave:        "6c7853999f6882df4b1602f3f1ba91231da8e6c4ad3862e9982127ae63ecb712"
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
