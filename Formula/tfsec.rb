class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.28.0.tar.gz"
  sha256 "f0ff26af74baae20f6d9973ea368782854cda7ff0acb764331de9f59742e239b"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15c526a16087a769d91ef60087b9258a8d077c3d155ef79b3d48931f04b45ca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ee7d967c022e492710c67b1572963959d66de675d2238d048334b61f29c07ae"
    sha256 cellar: :any_skip_relocation, monterey:       "04e46bd03e7787eb1424278bf84b8bc3648e25def179ba1599259e19ffa63955"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f35243b4f7087f616c2a8bc965ef734b7fa0afcf894f604a83035c0af810e44"
    sha256 cellar: :any_skip_relocation, catalina:       "1395d1f866e546935faafc0d457b10b8a35159d6ff487820fa5b3995c73e2f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c7b9f5d8d6b5af4435e9565995791b7333ab30ab7468dbfc23ce0fe77a4ae0"
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
