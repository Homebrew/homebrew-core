class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.23.tar.gz"
  sha256 "3dbe0feafea2452d5e465ec511271fac2eb5ca85bc47385ddd8cc1a37c3a2bba"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6c34ec12cac060888c4d7c258a037e2b75024f6d7aedd609d8503fcf35976a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "25cced66f4838369087a5bcb0b5579608831525888ac38f22abe19d273f536b6"
    sha256 cellar: :any_skip_relocation, catalina:      "4cc0c3eed6e131ab6cd176a6c4b814611f5383fba86c15ef8c39d2a4e3a2e9f4"
    sha256 cellar: :any_skip_relocation, mojave:        "1d06224e8d30128ebe6ab43d2cc2f34aa0a86a0e34e68b780c3efa76291bc8a1"
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
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    refute_match("WARNING", good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
