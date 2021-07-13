class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.45.8.tar.gz"
  sha256 "496dde6d46883125d59af4b8871a8a9451503bb711199303ba9b6134d138036d"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6bccb07138b8d83d4450ce126cf1d4caa4cf054a94ab21de690569d3190b2dc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb7fb341561765b037c1a3761ffa99d00e6a3f3f2bc5bb02a74883790262a06a"
    sha256 cellar: :any_skip_relocation, catalina:      "70972903a211fdcefc94f57fa8ff90eaf55bec08febf465242d41ed5f3552077"
    sha256 cellar: :any_skip_relocation, mojave:        "d923de81e7948db14b249bbe2d6bca50d72abb85da57b5b3e8eb28471cc45181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6fc5a9600ba4ef18f04deeec2610e846b33c9036356374fccb239f78a9e8778"
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
