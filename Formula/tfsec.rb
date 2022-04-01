class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.15.4.tar.gz"
  sha256 "ca9749a2a831183425a02cd82de494492353f43f61e594b1ad1bf6b57738a3a8"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b804a89f20d4d5d228a7b2e84fc30f326c23cafc6fe954df5698af5b9dde6898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "770d10e9f24754dc03ea723535d033823853874894f436cdae23b064e011aa6a"
    sha256 cellar: :any_skip_relocation, monterey:       "64e7c8ab7170e6880050b51421f433b346a27aed3502042a55c58b915727959c"
    sha256 cellar: :any_skip_relocation, big_sur:        "30d0d3b6c004505acd521d18e03265c1a212947b9b9c17330e91090a08620373"
    sha256 cellar: :any_skip_relocation, catalina:       "83ef2681901bcc49fe3d91f6876fb8ee037afc6313eec5ecb4a4c38846302421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5cc2ae7164b09194ff6bef0d0d98e3af737328d6663cdbd2656193d0f3c438b"
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
