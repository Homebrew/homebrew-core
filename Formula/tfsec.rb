class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.4.tar.gz"
  sha256 "aa20296840d561e6cb15df92aff812fa6210ccb6c9317c10015e6f9ce4e06201"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d9486bd68ec685f69c31b6efa53b5231ebba9da3eafc90958529cccbd6f5ad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55014bb930e276cdb5cb354a16c858575969d360958f478ff3b661e5ef158753"
    sha256 cellar: :any_skip_relocation, monterey:       "4e83e8d44934c78f550f703e216e468a3f642553657addedc0dc0499a333a2ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f05f529d87721af27bee49b5addd474e2151d03ce15aa50d1c90afc6405fd58"
    sha256 cellar: :any_skip_relocation, catalina:       "a9265214d639375f709c1927b08c9d31052d55b8cd5b8c5749c28082ec44190d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff789f736c942c102a11564fdf8e15458bdbbb46e5faf3e64c4aa073570e3b02"
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
