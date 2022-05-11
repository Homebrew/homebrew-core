class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.21.0.tar.gz"
  sha256 "d3ea2a68278a8a4fc0c6474b5ca5a358e900e309f46c0c88770b7302a3679ebd"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c028cabbad7ce1dc796bf4cb065aec3a8f6c082efbbe7c10c7f9ab8533d87262"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d22b46f11949a6b8ecb6822d3cc577960f4c741d6591da85cb3e2e62b975521"
    sha256 cellar: :any_skip_relocation, monterey:       "9a9ba8da56d619e81c32da9ae42a1edbd036521ca4ac9d96d6d9ee6f2b113304"
    sha256 cellar: :any_skip_relocation, big_sur:        "95005f3843d52fa03e3dbd56b33ed9e6c5ed211f404869f21a9b8b4d56b93808"
    sha256 cellar: :any_skip_relocation, catalina:       "488d35fa1f5ab878d9d2c0a0c48b12048b0f2091d9282e458509724c8dda541e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ced4938815f86415436747947353291eabb71740507d5b092beac85bec7b9a0"
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
