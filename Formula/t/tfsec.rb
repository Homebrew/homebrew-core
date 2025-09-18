class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://aquasecurity.github.io/tfsec/latest/"
  url "https://github.com/aquasecurity/tfsec/archive/refs/tags/v1.28.14.tar.gz"
  sha256 "61fe8ee670cceaf45d85c2789da66616d0045f8dbba4ec2b9db453436f9b9804"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb1908905eba53c4bc447ab6b45f55e8993f2baa1e5b0a6633185ce20087df9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf695583885541d5458402c40342efa2beebee6ad5cfce832c738bfc5b8a2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f94624c56f21064b7621e9d01c9cc78a60186864119a7f738b62d9fb97727b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c3fed3af871e78aa8129120ee048064e4f6bfc8a8d44a8aff8582a0e48732c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "181f6a3acfe91948ad4482b079d602bc1c03ad5c415c916f2dba42d590eed863"
    sha256 cellar: :any_skip_relocation, ventura:       "d7384e0c097b2e9668cd12a696f4b5bd6ae8df1832051fcafa32e6583b715057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ba4ea5c30dc01b827abd7f4f8719806a1a76ecda0ff3096a6a170a3461b4c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde3909cdd3d6c5e799ad913a640ba9d2ba2af6e7112254ab4d280335dda52cf"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~HCL
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    HCL
    (testpath/"bad/brew-validate.tf").write <<~HCL
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    HCL

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "1 potential problem(s) detected.", bad_output
  end
end
