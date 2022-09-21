class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.28.0.tar.gz"
  sha256 "f0ff26af74baae20f6d9973ea368782854cda7ff0acb764331de9f59742e239b"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7ea27fd39c71e741cdd34e8122415418dad593a7c89b51c7859dfce881bfba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4abc4dc08811bdc115b65f337bca7c17211a120f592952254dd939925b960cac"
    sha256 cellar: :any_skip_relocation, monterey:       "96e121c79bb71f529e459fd40acbbd9d74572d4a39569bb8a1990594debca0c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "489fbde7f01ba0d8e74240e44832fbd66f6205aabd03b54fd17739818bc27113"
    sha256 cellar: :any_skip_relocation, catalina:       "8573268bbf2a27ebb77b957bea803f8582f3cba87e6eece08d4f323b120777e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa896eb4edb16d3506b7ff336f7f03c910df1b22997b3a9d3e505041801caf1"
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
