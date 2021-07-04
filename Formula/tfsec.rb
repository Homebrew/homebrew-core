class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.40.8.tar.gz"
  sha256 "36a9dde1e4e3fdc3727f34c60e6f0a4685b1d4f797f156c9a95eaa1c20cbc188"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cd64a70dff267a7302bf06bc304b3e7d702318e97c4c065d8bef510c0035530"
    sha256 cellar: :any_skip_relocation, big_sur:       "6087d78a634ed6142cae502134771262c4c819459a1cfad306ac698f47d7385d"
    sha256 cellar: :any_skip_relocation, catalina:      "76c0470065b08b93213ac6068babf740118f3d974ca38ad219dec64880622834"
    sha256 cellar: :any_skip_relocation, mojave:        "7e867f3ff25a6ed9d498e15fc37473fddef1cd20ec62d9929e0302d09f154559"
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
