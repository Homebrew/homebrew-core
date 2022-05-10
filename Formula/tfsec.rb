class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.20.1.tar.gz"
  sha256 "6d7e343913cb6ba82860fc0d0f9ef2668d295958797174c88234af9b57bfc86d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0bc285026376c159d7546d8c81265b4cf0db9ef9140bac8128567ea1db9b2e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ece8e5aade4722f40903010966b1b5784cd7c05ea91f4564fb54b9594584adca"
    sha256 cellar: :any_skip_relocation, monterey:       "6798d09606e518fa6e475e3c1d2a6ac73764c18bfc06b40a13d631b049f98d6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "32fa42e45b02ca95281c0378ab64f033e0218fded0a2fe94c4ae7dbf9b3ad5fd"
    sha256 cellar: :any_skip_relocation, catalina:       "a6e56eba89b403cdd86b264cae4cd8faced10b380c7b12a4703ca8f736237fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948c2071abde5d6158be48638a9feb565d2dde2623bc7518285664f055c2e854"
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
