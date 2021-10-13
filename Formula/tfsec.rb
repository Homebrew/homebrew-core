class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.14.tar.gz"
  sha256 "79b37aed43dc12e4d5383e138603fe59f9cfd503d9ec839a5ec08322cfd544ee"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ce616515955602888c219c8393571e1a3f353ee728d84292edf050198bd9786"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd870c2295481d4185e20302da68bb9ba7a210fba9fb1583f94759ad42b864f7"
    sha256 cellar: :any_skip_relocation, catalina:      "520309c5407048736ef13bf7abad8a6b46c6ee462e0b417ab48436290ab3afe4"
    sha256 cellar: :any_skip_relocation, mojave:        "3bc49accf1843bf7ec4a2837c8a45bc2891d9a85b0b0b2a549dfbeffa178f656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6d12881ff0dd427a43ea0aaa9a6547c6f6c6a857f4e8649fdc9bae724a3808"
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
    assert_match "1 potential problems detected.", bad_output
  end
end
