class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.28.4.tar.gz"
  sha256 "a579076cdbd5fea3302c3ff5073869c6d861e9325a774cbe92b3ad0d55dc74bf"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3b8aa8779808e2c1b7a1c407405dca86e8823d9189c112c7ddb96260ff9e659"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db98abfecd67349929d69fe43e9b0f1df248be79b85092c6c17ae919bf730964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b1f88a0b892bfcd4ad59186cad5c56183cb94f787d87ef953f02facfda2de8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5683f35b3523890a978f9675848f8a839030b5fb7bc3fd0eab2c4f0e22739fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f3abe4a42f8ebedbbcef3b43323097309dc9c21be95c851742da731ac61ce4f"
    sha256 cellar: :any_skip_relocation, ventura:        "582495f90cbca181512812e1c5b5a53a7c56a77e33c45eb70185f3c8d22cc42a"
    sha256 cellar: :any_skip_relocation, monterey:       "8134265df428c4eb7172229dfb9dc08b02038c9419c083e3b355862bef965fa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c14c29b62b6fce55287e76bf293f1acb8a2976777dbd4a0b7d93f32f8f3bfeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e1beca194ef36c0533742c4a87ce4ba7a58aba07a40dbad3ad3074964338722"
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
