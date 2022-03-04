class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.6.1.tar.gz"
  sha256 "68984a3784ff0f992ca8c0f83c77db2ae49f23876915684d3cf2a00205963509"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ca58d0940816f02c593893be8592820086d808c752d327503ac9a8b4788a25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43fbb3bfd653ce5685388df0420aae62e60f4b85768412758a35e1234948a8ae"
    sha256 cellar: :any_skip_relocation, monterey:       "13340c3e59af8d43588d8a2bf7b6619ec46eb7617a6071262ee940c053d54b81"
    sha256 cellar: :any_skip_relocation, big_sur:        "61e455a3422bb8b0cdcadd89161c82e28de1c9b316896b524770181c2dfd9bc4"
    sha256 cellar: :any_skip_relocation, catalina:       "2228c12ebd1fac54bade6c8f9c179742d0e8368aa6402bf3d9a43200a7949e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f97c25daf9f55b31f44e0868d1227dbf39096f2d4cc01bc95bd7fa4ecad0bfef"
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
