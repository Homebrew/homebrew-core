class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.23.3.tar.gz"
  sha256 "0d8376aab59465bb2992ef950e4c706fda5108ae687fcfc5ed87310fa74c05d1"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e8ac70cb065133f985d26c9e6ba19c4e39c7fa3041c57c2e9b407c8722a9975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33710a96039cbe4cef4fca8b537be01058c5037bb65b9af59ad51915122c0751"
    sha256 cellar: :any_skip_relocation, monterey:       "c60f88c1d6f366dd3aa85c601f3d20a4a7a79f0e1f8e11ce028f0679c5e797d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4ec76fc41f9a778a9bd0ecedd7fffd16c450b6f9e5239f4bbdbe0adc2755433"
    sha256 cellar: :any_skip_relocation, catalina:       "0c0c05364d3b13b2baebfee7bcc77cdc321b37a874335e267a9bb364f5f63deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7a38f8c0eb461ce36a8fc6119b9702c607bd73a2ea58ac8ff590388bc84de7"
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
