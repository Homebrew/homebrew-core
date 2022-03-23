class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.13.1.tar.gz"
  sha256 "ac67c9f586872c0f50dcfc9ab083a14ff0c1820f7f7a15013af7f662b43400d3"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a23d134f2572002f6f3c530f3636ef82dcb1e49fcd3b99920a4b9b2024f91e87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77efae6270d8fafd55b36c17a99d0efbe92b77026d4254c75cdfb1cef06cfb3a"
    sha256 cellar: :any_skip_relocation, monterey:       "9734909ac538c09414ecea5062eab25eba76e8edfff9b9320cf4efd9d2f1ebea"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff492c354a6d7fb24875211091eeca937a03428980d132eea11f2de080792ae4"
    sha256 cellar: :any_skip_relocation, catalina:       "832a6d32b3fb361119fc2ac2ecddbb52bdde67c2d56c9fa2da41092c52d180d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e513df1e8b8ef612746702c8ff37b48f07c858f8238e5d031289a26d1a69dacd"
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
