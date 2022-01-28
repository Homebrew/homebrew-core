class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.0.0.tar.gz"
  sha256 "5204f7cd61d43cf7375f95275302196b06d4d9d8fbaa42bd62e0ac8ffd0ccd4d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdb0c38a1cef49bab45d3d81a02c19d3e83a45af442c7331ed7cab51af8c9db2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d5339ab2ebccad77868d5ca50cbba552d1bb650122fc03eb63bc31686cd2386"
    sha256 cellar: :any_skip_relocation, monterey:       "47c7b7d473d3178d6eb79e0175133c0482fd2833e91b3d36a0f99e80d06e2fb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1204beff79c4ab03a92f884d02ff298e9f4185ca5a74ad80360e99e67a0d70d"
    sha256 cellar: :any_skip_relocation, catalina:       "be5372794e97f81cd7671a8abc0be0c3ec56f96f815a9a60355ebd9ef85fcbfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ff579eba959d53d52ce4c6dd39cef1897b9139cb212dcd520fda2247544e38"
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
