class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.50.7.tar.gz"
  sha256 "a30c84ce6cb8edc9560a135a861304576404aaf7a927018271101b13c0a000dd"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6db1d299ef6921922138a5e2f5a48f2dbeeb3937bfbbd3c887b66386620a3bfe"
    sha256 cellar: :any_skip_relocation, big_sur:       "54955abe570ea9af87f256135b464744107cf75dea404aae67240c5348e0b643"
    sha256 cellar: :any_skip_relocation, catalina:      "a93400e5d2bff6cd964fb37b39d3869a81ed68adeeb49fe62c2b3aeb34886a70"
    sha256 cellar: :any_skip_relocation, mojave:        "c961372f378c9c9987a00837876931226e820880eecc6d372c028a65ba3dba2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d7a8c32550a91673be0bb40cecfedc8b687e272c79d908b933110d7f84cb3e"
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
