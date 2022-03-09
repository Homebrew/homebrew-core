class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.8.0.tar.gz"
  sha256 "9892cd029f83e1b9c827a62bc3a62da696d0e97fa7570636c0b866bd8ddb99e2"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80bab5ac783b55199215625a95b2a10a09d990f832a8d02de243bc91b515c20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "050c98f11749b04701f75dd25514ef3bac26f3ba5959cc3f1dfeee0dbb29c7b7"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc4afc082ff836662376c2fcca3443be3a79f178eb805ca61ddd99b6c4ea0a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1716b5c2413d806a50e91d2bb4a46242a27ada21e0894f703b40891a91baf99"
    sha256 cellar: :any_skip_relocation, catalina:       "ce0193c176190ca59178ed85c3c97e95c5777c86de1ddd96a885c00279174e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6102c8b54eac3408aaa462a7fdc72d1c4933de28e42a80314a9cb741097ba6f"
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
