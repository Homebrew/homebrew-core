class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.26.3.tar.gz"
  sha256 "c747e4ad1c2b3fc4637ad42729ecd8dacecf8537b332413771e34731e306070b"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abd4b2916f496d548016eb1d1ef6df489cd6bea120891f7e47fd3116e19dbf5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16392593bba4c02a44265656ec38ce86a87585fe093bbcdd108b4a437eb549d1"
    sha256 cellar: :any_skip_relocation, monterey:       "78f6b49d2249bb974ffbf25d109dd8fe7c6c1fe3c131a251764df50e97bb7aca"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d6e70dc05bdba09514af39514b2a2a78bfe9d56b42f1fcb6af7ca8a0136cc1c"
    sha256 cellar: :any_skip_relocation, catalina:       "23be8ff237fdef7c3495496e592b93854c992b4d342dcd714e6f3a84451a1129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c4bd821278ccca61f2a8d6bd6fec3d69ed82fe509a344a586f434ca1ae01e6"
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
