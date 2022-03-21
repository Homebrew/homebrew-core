class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v1.13.0.tar.gz"
  sha256 "61c4683bb2e1acccdbae23c91fac70acdfd15d2ea6172e62cbded7a3c4643d96"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0b0cef71ade01b83093491a4c31a677ff7d0d364dd50347395d73a2a6b1206f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e4c8d41e557fca8ad1419fa589041d9b4f9f465e00756a357a8b9a85e1863f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f326c9332a414b6708ed59bcb64b0cd7fdc208e7575c6534baf6488fc94d4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ede586c04eebb5a2b79606fa8374edc28136b4fe973b55c9cf390bf2ab06b49"
    sha256 cellar: :any_skip_relocation, catalina:       "52ffa4b234c7a05329d0c4685af0d92c72fbf566e384b24244819f6f8acc8634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc9cc555291f004ba22417cfbe0f9a161ccfa18dd0c9d64c7d96a0753c8392a"
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
