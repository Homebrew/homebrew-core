class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.40.6.tar.gz"
  sha256 "d3c6a841ac72566b813bfaeb0af94221601f8ca976d72269a905e61a40786dbe"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9408b3e760e66bd67f008651b2623163ad2427639b63d5bd78f13d81bffe0cf8"
    sha256 cellar: :any_skip_relocation, big_sur:       "003a2223a1565fec878af5da380e9cade5b4c83c4a37fde72bd02cd1f9d8343b"
    sha256 cellar: :any_skip_relocation, catalina:      "059a79959d91c255b04effcedb4c6a670abf353feaed340bc9dbdb3971769233"
    sha256 cellar: :any_skip_relocation, mojave:        "f282b09b591f1fd7f9baf599eb81c757ef186fdbeafd688c8e7f323b7744d8f0"
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
    assert_match "WARNING", bad_output
  end
end
