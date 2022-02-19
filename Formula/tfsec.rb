class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.4.0.tar.gz"
  sha256 "b466dba7dd1de27d5a39710cdcc68154ae7768fab90f5ebe84c38bf6b48174de"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7188cd7721840d83cbc86a3a53f1f9397a2fc0db91b16e0cde31b2284f34dd07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "607829ff96ad39609c285fafba0364a26dd9e14055002915b2643c1b9a3b390f"
    sha256 cellar: :any_skip_relocation, monterey:       "dd7351631f8aff9a2208e69e4e0e4da1a39177060dd45064898b727e6b063b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "250c8d945ba545df3ef66dfca64d27992d045459677b0efe230b503392a88109"
    sha256 cellar: :any_skip_relocation, catalina:       "91440457b8552eebead8689b806bd5ae92cb0e182806328140eb05aa338e52ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8268aa9e97cfc63e92f6b24e3564caae557652d4ecbb29c45d5868af1bb3006e"
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
