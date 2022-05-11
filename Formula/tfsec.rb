class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.20.2.tar.gz"
  sha256 "df9cc5d20912c611a9f98ed30fc7158b8a1afebbe650c22b17c0df39a2930ca9"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fae2d9b8ae2e945215788efb5c5fec95f8f8824eee961bdafca7bba356cf857"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68385c059c82b1ab439b77343c5720285934b0e9d60a1323434d7c39feb809f"
    sha256 cellar: :any_skip_relocation, monterey:       "9ed9596965ce9b350f9ee2788edfee5bee2fb99ad9b44867f7033586a674aa8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e93cebfd35a736bdef2da17f5a317c044c4acbfe4271a467b0247e5ba7b3b31"
    sha256 cellar: :any_skip_relocation, catalina:       "5de9db629c0cb6b17d7e8e7ef6bba8ca57f3a65324ffbf532b5e63631152edf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6241a82bf6a2ab87abd178b0b48de837d916912194fd520d65060fce76fcd10"
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
