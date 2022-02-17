class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.2.0.tar.gz"
  sha256 "ae41b4e0e004c7702cf06e673d638d4d7525590a29f168dea6a48a5c826a994e"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299ea640914e9f34b3074435b25abc2ea8cf856cdd968666798f1f9252f20c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2988ab5541f3a101d9460eb486279bc57965ea0b785a1d4a166b597d10d8d448"
    sha256 cellar: :any_skip_relocation, monterey:       "2a7ef06bfa5f6697fe1e96274e5f385ebdd6af9fc42c8c82f488e8e152ff9e23"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdaf808dfc8757ff25ca931868baa3a8d77f994803652fb282d4df0c376a0f87"
    sha256 cellar: :any_skip_relocation, catalina:       "4039a39d12825187b9237ed11c13fff3da5cf998791aa98e573c4fb4c4e6fbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9eefb91df323c15c401e56266c844f245a265d214baf275edfdfdd7e337a5ea"
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
    assert_match "1 potential problem(s) detected.", bad_output
  end
end
