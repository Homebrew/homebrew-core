class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.27.0.tar.gz"
  sha256 "0e0c07f27f6f8743f8afe5875749911d7964bce5f4c52c6a72b0097df2fb4a58"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4625ce27c233183a6c9d7321974e4b4cf57cacc24d16ec1b1422282f82ef9587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e5292e467a124c9333474b458c665cd5ca885fb40e3e0ad7902ae0b5e896ebf"
    sha256 cellar: :any_skip_relocation, monterey:       "f528f9ad8c116dfd472928b58a1c4da29e3a6102b257de3258c7261187e9c419"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee906d0f5abbb89379dbc3b3095948912bb5885f864c33e37931e6659284507"
    sha256 cellar: :any_skip_relocation, catalina:       "01493bfdc49b9e7c63c79a6f9ea8ea5f501b0f6a64c21c720874912856dd74e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ee9e40aa9bf0da2cb86eb35c7788f953a8e5d410881747f7d82c6814164247"
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
