class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.4.tar.gz"
  sha256 "f9d6975695d947af0c923d396d73d75d397a1941ef28d29b5c42f6ff98055d0f"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f3ca5b7016f9cbe43259a8a22c8ec856d36140df976c7de942f21b2a6a97ae35"
    sha256 cellar: :any_skip_relocation, big_sur:       "5eb83607f31e40f39464e6ccc7bff1ae4d1b896f6fe87ae97939cbb510c5fa6e"
    sha256 cellar: :any_skip_relocation, catalina:      "7f84c18fd013024aefd3e64e9ff675394a503acee50858eaff5fc04b84040673"
    sha256 cellar: :any_skip_relocation, mojave:        "c6df6961c29d5260504ccb6373ce436fccf2408489c11cc36e1ba383b87ea3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d386867174ee4ce476a7febb5eb649cc30062ef4a843e1112ac96198f77cfe9"
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
