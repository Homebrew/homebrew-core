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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09dcbd361c53e544ffda3007887bb330e99c2c15e07421aef16d79a821183b02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f78a9ef77a69881c4b67e7a3c8b7cfa0a0c2b59f510a6e89c61a39886d3fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "c5184c1f21fd3e6b3a2a70a563a8e13d6e510e5e881d9aab4cb12bd41d9db089"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb89329c789a3583a5bf52c1cbf3caa0c5b071594a36908d251d3d76cb40ee38"
    sha256 cellar: :any_skip_relocation, catalina:       "534630508add4340240392eb802af5e7a04116b4e80b43eb954bef7176204aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2fa8c495663795e022db6ee9b006d86b2424b80347f7b25ba25a60f4f8f328f"
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
