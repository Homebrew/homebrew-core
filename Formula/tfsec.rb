class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.13.1.tar.gz"
  sha256 "ac67c9f586872c0f50dcfc9ab083a14ff0c1820f7f7a15013af7f662b43400d3"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1afa5487a95332400b828387f7130f0226d04cca7ce427e3f0cde0e207ffeb0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5385008c84707134e9c679eb233bf3f2d10bce83addef13c30998e7219139f75"
    sha256 cellar: :any_skip_relocation, monterey:       "fc96e446edfd50a30bbfa63a39e398b98a2562ae3bdd55903360f588a2d7891e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6d71b62d0bae82b4b4635fc70ddce993132966fd1c7dc72783b7fc9239e3d94"
    sha256 cellar: :any_skip_relocation, catalina:       "44327020a57462949db793df94c5edd63e936bc66dfe3fa5e70c4202d9c3d793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a64f758c562308596fa3cc8c9a1a2115cd22d0c9def7cc7a60423656fd8cc7"
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
