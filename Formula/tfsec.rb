class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.5.0.tar.gz"
  sha256 "ebeb3393bdc5911335e5c7a1c38d34f75381d644c0964bbf8d0611b7fe9b0e4e"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f452a415f71a77510f31dbaf5356977ba0de90c943b6613dedc5572f17449966"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9b987265e2b52df3b24480d1bc30f961923db0d3378aad6647c34373455463a"
    sha256 cellar: :any_skip_relocation, monterey:       "0bca709a3f53cd3c6182900ff138ed31a8f22de3be553cc1ae707dd83d9639cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "432b8f9fbddc0abb79ff98494529ffb510b3b1174910e500d97a804a8cfb0bca"
    sha256 cellar: :any_skip_relocation, catalina:       "408fb992a460cd74e60b63c5533585d1e5cc80f69e8117136b404a3229f7bb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb0d55c19189a23bdc95ea02a975871518f6cbbaa8f98be46779f361a5c6d423"
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
