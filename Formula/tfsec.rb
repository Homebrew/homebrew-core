class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.21.1.tar.gz"
  sha256 "5559d7283e44e50a00d511a8304781f05dda481062cfd8ad404115dd0c6aedff"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c5160b5ab9822d8d5c2dc65766b1e114a7b744a526cbaaaa2d984a705a08a23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef2adfb048f29b54c6a168c3da7a2aa9dc457c71b72544d17c8f03c1861b7db9"
    sha256 cellar: :any_skip_relocation, monterey:       "ee43460a39e99d6b7297dbbb81eb3181e0100b8dd719e329ad1937b38ea606ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "30c61279e008d7de7903c4d7b7288c48c8267e1c9923ec485f0af93636f7858b"
    sha256 cellar: :any_skip_relocation, catalina:       "3be97b7c9b67e9adfbfb255d732febba9ec8b028e9a33a1ab8f2003c45232500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e378f7552e22e53673e7bd43941758901d725acf5c34cfdbd9cd80a6b3b63e33"
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
