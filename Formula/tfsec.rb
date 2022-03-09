class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.8.0.tar.gz"
  sha256 "9892cd029f83e1b9c827a62bc3a62da696d0e97fa7570636c0b866bd8ddb99e2"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31baa047ef3021ccd68d32100c2def5e17d088e2e02aa7dcf3c4c2faaa9a3119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8a69cd0945642c448192d2b2ef419d5bb528fcf0708b9e582c645f4567a9c0a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ba361b48da3d3142190bdbe959603e80f4ba462a3b89cfd6af409639d3a6eba"
    sha256 cellar: :any_skip_relocation, big_sur:        "c38342d989f7a19abeb47453aa25ecb9a01ea5c5b98dea6a2dc84a687ed9d223"
    sha256 cellar: :any_skip_relocation, catalina:       "bb45e7395eef6080074c1e29f81c05c233970bc63dd9f248279f1f8628c56f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4394ec0a0ed9a189a4a68858ffbb2165541da4b0e90b95c8cf395b40d8acd7b6"
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
