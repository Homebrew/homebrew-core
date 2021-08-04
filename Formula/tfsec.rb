class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.55.1.tar.gz"
  sha256 "388dc4e57782663389b359a27374417729608aedba6b64974817d7e66300bafc"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc0449e35b2512d99beae4d0e51260483304bc62d51f50a2fdd089532b5996bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "59aad4d915407f67feeee7385874c3ddb05fc25ceb913e763134bfa7e237c933"
    sha256 cellar: :any_skip_relocation, catalina:      "f6b561c7a758cd6839362551b2bd5d7e01ab31d3ac4752bd7b79878c9e8b05d2"
    sha256 cellar: :any_skip_relocation, mojave:        "c98eba5d0e527bb67fd05707b651fcfe36f78a1bedce328ec6719396b7834af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dc13989e31b91d7bb1c6593ae30406401796a741f90bb9ef44e95203fe632e0"
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
