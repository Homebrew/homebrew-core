class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.52.1.tar.gz"
  sha256 "66565d07cd21066b8b91ecc5c5ca37f88c29e8af0c448ac094f7deb55bfa087f"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "929abc2ae8ee7f1432b27db43e83e0d032db4cea57d232306143b7fdafa67d0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "2abb26540bd0edaf70e3e3026b8c39a83b9bc578df10a073f62a956d2679ea24"
    sha256 cellar: :any_skip_relocation, catalina:      "4860005cd6ec788ec54841c0359909ea711b4566ae63fd8787e7ee060f081010"
    sha256 cellar: :any_skip_relocation, mojave:        "71272323afbf125c1c6bea4538ed1732f085abfc35e40d7c61eee9e08cc51ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f3cb9af014e16863c59431e4261733d728ba5a6610075f89cee05a387c7965"
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
