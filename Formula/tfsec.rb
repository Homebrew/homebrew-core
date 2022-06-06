class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.22.1.tar.gz"
  sha256 "0a424ddeedf53e2f66455183703675853327865fd6da96f92ac36f21bcbbaca2"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39422bae5583229bc025004aa021ee0b97384111059779426a56e5701f02f086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd09b3df6f7e18acb5abab8be29c8540f3fdbacd8a6bc6a4b4dbff3a76b85ae"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1451b57a10b2fb0206bb436cfd11f261c9fdb6512273b345dad557e0c2abc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d577abb02a4b317693952fc5e186cb59784e1e96fdf71093243825431fa68e1"
    sha256 cellar: :any_skip_relocation, catalina:       "e3d86532b10424f7b32978c8e82c1b72ed344c1394d0ed821b3ab2a8577dcf2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd53a152c0916be07100060368cb2c859e0dd38fa2a2e3e4af6e02482d1b33f"
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
