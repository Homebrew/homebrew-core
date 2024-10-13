class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://aquasecurity.github.io/tfsec/latest/"
  url "https://github.com/aquasecurity/tfsec/archive/refs/tags/v1.28.11.tar.gz"
  sha256 "9fed7ad6b7098ca0af355cc602b7de9cbaf6b3cff48ff6fa6f22e6a2c0063d4e"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29455807b979ba66386fa129b9d0827d10d1d362764934386bbda7ba7ec044c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e039ed1d8a3d0ef48b10393f94fb4c5b0ccc1379318cb3df596977d8ad0d18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9dfc5b29eff53522c79387494996362c55ce39ed65579418090e8269fd7237b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c392b4ffd680c08337121a69d02a3eeb1bdb8ad645c4533a2f7cb14b5c37574e"
    sha256 cellar: :any_skip_relocation, ventura:       "4f8b712f23cd0331010a9ae1d302976674f213739faa58220739a4af72b41fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08813a6aa7e03e8f8f2c33688ce63d23944e70b211437134063fe03fc58bad4e"
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
