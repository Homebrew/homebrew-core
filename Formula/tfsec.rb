class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.22.0.tar.gz"
  sha256 "54da2e7b93fd31a7e9fe111b4fa732cb1eee965bad80a802ac06ee5505e27424"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37abdc81068315bc28b1f51b70877dff29fca0b7b026aa158b04ae97eb6bfacd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a41ccbfb9aefdfc5d3b99df0de877d4d4dd7b661bc0f2ccd85ff305baadfa7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "e53d9d0f0cb11ea3ef3f16a777f59018a5b408b7490df6db0ac9dfebad7c08c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "db193129fa9522ae867c4a646f54a95caec689b07b2cf9c3965e334261dcf03f"
    sha256 cellar: :any_skip_relocation, catalina:       "a372d10eb95f1cc483712a5db9caba56d823c18a9892593042a1cc5438839327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8282a1549f6deb468802ff08db7206683c096ca89bf6ecc2703000dfc8648d39"
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
