class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.1.5.tar.gz"
  sha256 "b7870594c6730039a28475ae630e6cff4acd70f2be9357e0b6da9284b2a03a14"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "884a574c80b1aa1d23cb9fb7e7928d622a72d994e67ec68d425a6ecf52b50dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22be7ae8fe1eb1b30b3019f0c5a6ad78c19fc3c4b992e388768d8322989b06a8"
    sha256 cellar: :any_skip_relocation, monterey:       "142c7589da67b64ef3d610d32be38e27d384b38f92f3221474396c514e4b31e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30048dc15ab2859d6f23e11d1c1f6051e93b38f945b8e2bd98744ca44915a79"
    sha256 cellar: :any_skip_relocation, catalina:       "d5b97600a999c763ec5bd39601c48eae6b2bb79263b5a14bcf8ba27d5ccf77db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aba2dc0bfb9083bdbd21eb360d49f42a8df4838ca46e2585bc30ad22997d431"
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
