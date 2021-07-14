class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.48.2.tar.gz"
  sha256 "6b255e1935d74a40eeededdadfe1bf18fc6b390c10280437abed602c9c3fe8af"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dcc2e4db70abef2e3fa98d5ebe9a090b3bd0ac22b8dfa858a1fef042593f6e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "47648c927b28b2d801bd2be81c54c2625f6ff3577a2947a99b6d2f8012e7a6e2"
    sha256 cellar: :any_skip_relocation, catalina:      "f4df4875d9afc07cafdcc5f0f77941a1f9ca91a327964f30231dd4347f7e871d"
    sha256 cellar: :any_skip_relocation, mojave:        "ae7827b841033c500e214fc82e4125eed4c92544f1041ed742f066c037bcf519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3349dda5e34dfb61536e12d9129410fb0475707be3e7d9b45b95acd2efd0cad8"
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
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "1 potential problems detected.", bad_output
  end
end
