class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.0.8.tar.gz"
  sha256 "88b09b0b914deebf142d1b739ab20491b3e5fc5f2f4cb0cc84578f884b6bc906"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5914a1ba25034e2f351161919bf3cd722d2b3cf11667ab671a3d08657fc21b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e5d7498f57da8801969013c80f425281fe3e61f7f55cc2ead1d208eeda3cdf9"
    sha256 cellar: :any_skip_relocation, monterey:       "a8edc43e5e8d857a92897c453aba55bb0d30a50673485e148d4ad4ff7e3e2622"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0371864f9af36d7621f3c46e962219d334e38b842f62d2ac1300e7204d774f3"
    sha256 cellar: :any_skip_relocation, catalina:       "2ed1ce4c4650f22a67dec0889325fa23ff32eb82ce1611322027cc3c6ff26248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147d286ce440ed6946dbbf854e9e9f8efc4798bb0e1c3dfa8f7ce22c8aec710a"
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
