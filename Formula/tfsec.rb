class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.21.2.tar.gz"
  sha256 "eb59ecf6b66f6b67a7e94dc9a348fea4fe1eb85359de9082594b4c6f26a09488"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a8b9c2979341b69cf5ba376c3afae6c8cf16c9b8dc8db39b26c1f0d6514dee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d4200ddfd9f0c79daa81cc2ccbc0f15bef16211257f61769c532bd962f22427"
    sha256 cellar: :any_skip_relocation, monterey:       "973e52883ecbd1d559848f787242d5ea7516a5683205fb98867a4c82ce924963"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a87935beb71825dc207375092a19bce52f473dca3bc2693d2538844256eca21"
    sha256 cellar: :any_skip_relocation, catalina:       "d69cb5b224071c8599ca76421b709366d79ad033fab06f50f16a382972150b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78cbffce4001255361ee39de5434e6239c1249acde945dd0776903a0ba5381c0"
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
