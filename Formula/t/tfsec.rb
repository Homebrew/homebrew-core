class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.28.1.tar.gz"
  sha256 "17c12304ae34bdb0cc9de916203a45077a96a2786084edc6bebf7b769dc430e8"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c613d8e9870a22de28adcc65fa7a2a1d7ddaeedfd14cc8966c11f057ea5364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28e873bae875501992643842e3d37b39b38bc50da2de354d7444c9d65c74c4dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e520df9e90c9bf4604705fa16d416fd54f0f02ccdc1faab8395a8fe375f192bb"
    sha256 cellar: :any_skip_relocation, ventura:        "c9672ad68b8c040eb6935b7cdb07b62485f4aef3773c630ff1dee2c8d174571c"
    sha256 cellar: :any_skip_relocation, monterey:       "21becf100e3e147ef5811701e2fda70b3b5b5affdebe9d90bfcf415b6e6a85c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "65c603b1e4c85f3951a9295fdab06469b73837ba64dfcb4f915e435e8208c94f"
    sha256 cellar: :any_skip_relocation, catalina:       "175dd35759be01a52471ed985c03ff7981a2c0e95cbfeb8cc42821e130060311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4f23d9e8878a3da734303381305611634d7bc833a2b9fd4f336a89e6c0806d"
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
