class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.60.1.tar.gz"
  sha256 "be164300735b21e3dea96b5f4d82f020f7b738fae5531ce4abd7f6c59125e270"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17d0a68bebe25c3bff070b77174f60261bab1d41b6179ad5fcd3aa6b2e53b5ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c2a76f804e5c1e486e3d7b7e75e6abaf080c38b1546c33e4f22a92d48a3f57f"
    sha256 cellar: :any_skip_relocation, monterey:       "46b900da60449adc471b2a039f6afc92a65ed4a6dd9f0b6bc66bd27e7b2bd52e"
    sha256 cellar: :any_skip_relocation, big_sur:        "66e51458e0bce14c7ea3c79d750137a257f7f9fb8cf599954ddfb0b7361eef40"
    sha256 cellar: :any_skip_relocation, catalina:       "1a2dcec5f31dd2736028b63b4118d5d2868663a9f014844053298e236ef464e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82583dd0ec61736c634877ad4d4557be036c878b67bcf5d13e2a99eef676e492"
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
