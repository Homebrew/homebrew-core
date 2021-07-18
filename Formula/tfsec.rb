class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.48.7.tar.gz"
  sha256 "f9587b3d77a3af92994282cf4196d2274d75a9d2f1bc730b5d7d852c9808bde4"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe80ed11b5fb424d0431796b38a6761e2e9fe66d7fd077df37ecca3d768d5993"
    sha256 cellar: :any_skip_relocation, big_sur:       "d173229bf340b1c189bcc3ad0162f485b0726bb2e4bfd3c1ec4de06b6985eef0"
    sha256 cellar: :any_skip_relocation, catalina:      "aeb30c14de511996a7a993a1062bccbfe183970bf91f65aceaead8ff0cda7773"
    sha256 cellar: :any_skip_relocation, mojave:        "7e733de57f0b6e9dbb132c558dd82ee2ff8473497ae1dae94f0b58100d7b2599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6fba16fff69400a470d7d6cfc52de79ce806d4a4f034dbf6cbc161ef1afc22"
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
