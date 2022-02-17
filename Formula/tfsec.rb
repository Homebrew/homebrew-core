class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.2.1.tar.gz"
  sha256 "8b9c329025fd3a2c6ca0e10362fd425c39312549e93be37f315a13bf440dace6"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14fe63dc45cf47fd67799c8497e4e8f3d2a45c2bc0bd4c68d99c2c457e439e35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f2d04dc96bbb617113ef4988af930178db6e15410d819e7e1ad3dd83fc64db"
    sha256 cellar: :any_skip_relocation, monterey:       "d777f1aee07f4732027e29237d2eb42a88fbc21247cb3be4dbc6395e040bd369"
    sha256 cellar: :any_skip_relocation, big_sur:        "be762feece2cee9ab24c04cfc9538b72be5f7c211308ee418121431750ff0350"
    sha256 cellar: :any_skip_relocation, catalina:       "9a56f47958c0ba6c430e4d325a5fbbd50aa04f358c5f7803ca494d31be56dc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1239a63c48e9202edaf4f7a95b6920f7992639753e2cc2c224a58e8cac589dc"
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
