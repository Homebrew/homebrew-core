class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.19.1.tar.gz"
  sha256 "c73f78558d27c58881063243b14c9176760f8c288d17eae82c341bd0251155fe"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f913ec0ed0e40651667d3cb5ffdf95c6d91cc2203585e4e7707bb3a6a8fb3ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a377e3ffbfb1552374c9751a67f9c925d64274be166e4a2b1edaf3fcd101047"
    sha256 cellar: :any_skip_relocation, monterey:       "b0b9baf667607e860451e7bd76d0ca4395674d059bcf7fe4a82fadcf46547dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e8aa4661917c485402e68a61ccf10280329503a9dc41bf6aa430899a6b7bb25"
    sha256 cellar: :any_skip_relocation, catalina:       "440bcd12d3c9f52bf38e3b2babb163595cbbcdf3c7df5886e601e7ac27e924b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e45f7dba82860d546f65b919f14210e6316ba8a7de2dadf98f58cbfe6983562"
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
