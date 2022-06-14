class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.24.3.tar.gz"
  sha256 "4caa4c8caafc5184fe5c46336490869259c76be207ab40debab21e59a4599624"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf93b695515f77bf37ea9609c3ae54697aba031c1138cb9d4d9a156d012aae89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2b8f50a83e0a43f9f56d55fd16fa179c42e2da5bf7d6a48b8244ba242c54db6"
    sha256 cellar: :any_skip_relocation, monterey:       "729dc7a26fbf221375ebf3772fd22ad9931a6fb58ccd04e3da3dfdc3b2edc87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c29804b55c2bd03eb7a8831a45f08bde1cf1b7511aac691a7b8005395e826b3"
    sha256 cellar: :any_skip_relocation, catalina:       "ff493f0cf115ec189d834e1abb229ebad857fba5d5c649da105b35c29b3566be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "465c64fefe0a638ac7fff447ffee43c1ff29153209e8b692043c0cd6ae7d61f4"
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
