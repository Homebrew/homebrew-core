class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.6.1.tar.gz"
  sha256 "68984a3784ff0f992ca8c0f83c77db2ae49f23876915684d3cf2a00205963509"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162987d9b2abd793a3bcd46043cf7ef2108774712a455feb3790a51022d7bc10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c3e97987211c869f5ceb5b39cb01750e2b34989226b9d653c3c44a7ab900da"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6546d620ec0cbd0555ad2c810cde20e551b477d2b5d3d85c76c2653d2fe05b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7784e32106a4b4f0c985439d813ddd06432dcb38be0e4236758330a9315be162"
    sha256 cellar: :any_skip_relocation, catalina:       "142a69dcdc5652866b8954bad438670bf842e785dcd9b8da25271242acc384ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125ae7a7adf11c76eda4ad2db7a750bd13d0d4c95cc5007eb5d16c3a8e43ce5a"
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
