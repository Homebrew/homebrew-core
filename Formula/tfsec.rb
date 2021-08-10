class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.56.0.tar.gz"
  sha256 "f39ec3853b779d5642b564a8ae4af743d2fdaa3fbb360627d1f595c47aa10aa9"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b674113556c1e4b015bf35cc1d814b20fc6c42c141b2632c0d5f19f53fb9147e"
    sha256 cellar: :any_skip_relocation, big_sur:       "2765c56f353d83c6729df47c7226f20902cf56e3d1d9ff167e8f4a325db22aeb"
    sha256 cellar: :any_skip_relocation, catalina:      "c7ce15a1d552817acce10d7520b0463b36e5450d9794dcd736f6d08cb3443be1"
    sha256 cellar: :any_skip_relocation, mojave:        "08c20adf37fc7d6c9327a24660037a544510246c9f6bf41e983e4f6aff0ab660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c2bca743945d71f09fa35998793a829797c208d3581eb0d9b5e0ee03b9322a"
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
