class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.9.tar.gz"
  sha256 "d4af2a5edf40d14d580141727cbd36eec65860f7b86bfff22f30d9f12b0d6823"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed1b59d535956faaeb96fe84c1db1ecd1b67a56e80fd4b47c79c0a056230f82a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b105daa02a9c075efbcb507b10a8151b9f8337df050e1224fef3bb0030e9271"
    sha256 cellar: :any_skip_relocation, catalina:      "384d724b5a9814c14600efd43bbe490c3a4ef5cba79267ad215634e1d9310060"
    sha256 cellar: :any_skip_relocation, mojave:        "f2902061e3f423e748f4e4f07f1ba5aca47119c5160f8d1fad49928cfbba4915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a886d752301dcd83e34e34cb2d8074a823ec46324bbd8c2d8a94e1013ef29992"
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
