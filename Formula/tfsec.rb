class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.11.0.tar.gz"
  sha256 "31413d2b7ff7e412a164d93cf729ab46fe28dc9bfdd09b507d6ee709df7fa0dd"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f02be843662e4252823865b58fa4936dd6e1c522f585f38f5cfeec51f286ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "673313b0fb7eb5595b1bcd80de14faa66cba635b7a111c55a3dc1455068aa507"
    sha256 cellar: :any_skip_relocation, monterey:       "4982ff5b546065940a57f5effd19964c6b2db9e62f6d340be2d017cd4737186c"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b357641d1805fdaac8e6013e11944accf8ccfaf3e6e5c21465e577fd02bae9"
    sha256 cellar: :any_skip_relocation, catalina:       "675abfcf8701598416347feb426b4124e7da3df6a73591a00e903b9790924dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbcf411562011b8b2f9e4d8e24204e472b086c3e6ca9d978ffe0e8587306972"
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
