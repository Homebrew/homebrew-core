class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.61.3.tar.gz"
  sha256 "fb17159dc6b0852a74ca75533269856dc176fa00ffb993d6dcd2933a0cb7a2e1"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "847de4b14fd5755a6809c741a5f596c76ce1a97f68090213dcddbead250d919c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0922450ffb7a8a9ebcebd79692d827fe3c0c781074f9eb447d9b0d88973ca3a3"
    sha256 cellar: :any_skip_relocation, monterey:       "682e7953bfebf96e6d1bddcee2409d5410dec953e74ba5fa21571472e3035fa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c260f0c867008836747afa8ae0c834f3bf61de32bae6e86e27d93c74cf9bec35"
    sha256 cellar: :any_skip_relocation, catalina:       "fed73998df1f2757515cc5316d34be2c3f46bd3d99a6a772328b5d65a8c9c380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab8b27d4bc03c134f3780de88b34229af5691f4e48817efbfcf07059ac809b9b"
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
