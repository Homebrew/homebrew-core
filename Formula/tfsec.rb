class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.4.0.tar.gz"
  sha256 "b466dba7dd1de27d5a39710cdcc68154ae7768fab90f5ebe84c38bf6b48174de"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c39a075d1dab52e232a8512942f91dbc94ed449e2580758d0c5c2e53bd78010f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73f9cef8d1e05ae28ded5b529d35938e61ba23fd52ceaa8210e96457de2ad620"
    sha256 cellar: :any_skip_relocation, monterey:       "08d75d3a16af1a95624d8295e5b222c8f2bfb30da92d0aed6da50d14e4c034b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e7eae0a687bd1e6126b57862b0c81158341b5d72ae8dd8116601216376ac09c"
    sha256 cellar: :any_skip_relocation, catalina:       "87ba8224503fc156dd02cfdbb0e47ad828aa667f894ef4dc8f221e3af4b6c0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5295e889ae516b5b2b7e9279cf0106ecdeb38e5cd16d422afb0817d04557c1"
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
