class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.53.2.tar.gz"
  sha256 "ec33880a97bf8f5c66b442bc93975231daaafc04799a6fcf713ee53091777428"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e9eeac02567e4bb499746ea8c8fd893fd3725e442c8a4b2cef0b65506765565"
    sha256 cellar: :any_skip_relocation, big_sur:       "71889b15b8aa6302b510cc568928e36671f2cfc4af9706d0317942c79dd56afe"
    sha256 cellar: :any_skip_relocation, catalina:      "4a75ea93f269b565ef3aab547adf356c8841b593d85cf10c5430a2aa6b548581"
    sha256 cellar: :any_skip_relocation, mojave:        "80c406a8ef71aae16ae5665009007c8f09f7c5352397cd7502620503c06c6c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18ecec3c4e8089bf4870b9a877601dfd1440d6b5001564100b7eadaf6097685"
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
