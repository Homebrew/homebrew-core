class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.50.6.tar.gz"
  sha256 "d3ce6d0d061de72eba28bb87ed6d268d258402cafee2f08eaac883c9f592d48d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d788ad7e1138e928cef4d781675a4d7ff0d1dbd27a4b07bb8879a7bd72408bd1"
    sha256 cellar: :any_skip_relocation, big_sur:       "285eed8b4086bc4c6123cf9dd0ac8af0e8aad679bfee93984b753a622faba8df"
    sha256 cellar: :any_skip_relocation, catalina:      "93282f748ec02a3f24b0a7cd97b36022e437412dfe31b03240410f2315d4c323"
    sha256 cellar: :any_skip_relocation, mojave:        "b64ddee36484cb142a4c7740fd733c971fc79a62743a9f69352843e562a55412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a01967d1a739f728a1b8ac40fa85d5bd3448058fb430c900bf3a39da3c6206b"
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
