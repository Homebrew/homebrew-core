class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.24.4.tar.gz"
  sha256 "bc7b1782f79f3c2ef8b447144bb7c0aa33624b069e8e04ff0cea7f45ff307d3c"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9dbc5104e1c5b085db77b5250ce49d2da8553de585ea6f70f88b4dd46aaf5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef748037403cb6c6e487e48e8f4c6ff078bd367827680b77b43e755e88f0461d"
    sha256 cellar: :any_skip_relocation, monterey:       "73c25a43a963f40b43cd7d3e63be872ca5ab329551c0d8f61c019ff072cb0344"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31e65adaf4d31d96359e0ef8ab3d94df9dbb3ff97578a5ecd0eaf667cf47437"
    sha256 cellar: :any_skip_relocation, catalina:       "70e44af22c100d73240deb42164cfb02f8fd0ad027526dcf19fe326dc76fc13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc13d6190c9c05a3806fc02b4f9ef3b29c33439dc9eabeafe8397a005332f878"
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
