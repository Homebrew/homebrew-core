class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.6.2.tar.gz"
  sha256 "73525c1efe2c32452194f7e4c500f6234c6806a3bf78b728252f4aea12599d50"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d3910dea5b6e7621ea7e44bb3eefb60e0aee02d33d234a2006e9555e3c1f98e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0895b89b148042360facb76d9665a3e0d11d93008a22e3dab33b0aeeef097b39"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd73e41ea1e7194c4e9dce3da163a724f5a836ac457255b2cb6f901842679d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "edb0ae535042ebefb8921b2ba2cee9b8eb216f0d924c101739e99af29d0c643b"
    sha256 cellar: :any_skip_relocation, catalina:       "2377718ae56256c9eb9dd646d1fb01d94a38d16d152eec435d50305dc530c01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d95b1f9ea6e763251711a4f972d01b122955385f9b220238c9cc136d78ed4a"
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
