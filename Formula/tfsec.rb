class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.1.4.tar.gz"
  sha256 "512b9c503d8eedd5768ab2f66208af5519813d126b0fa0d8d937cb9e2b112f09"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21aeafb0f4354015c36058c314d49794a635086ef1b9c811b6f4e4bc1cb60441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e65e6cf5c57c610bcf036e1a22957a082bc00f19665ceed71adb19064f9164f"
    sha256 cellar: :any_skip_relocation, monterey:       "9768796bbbb53e11693944aa81acd9f489a61bc26dc8d07f4da7a5247d614941"
    sha256 cellar: :any_skip_relocation, big_sur:        "b352989fe3eae690728aa0c5278200ff05b6973afa4edcc09c6c1a33ac82eee7"
    sha256 cellar: :any_skip_relocation, catalina:       "c942554654880f8b3c065b1977f94ff4c6bdf389ae2abcaeac28cf3365fe2e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cdd320054f6a313bb87f4a1d427cf439e9a98f87f30d219750d9da71e1584e6"
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
