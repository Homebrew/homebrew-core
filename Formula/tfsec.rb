class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.24.tar.gz"
  sha256 "c316efcb7b82e2af53a0bb6b9b7f08a78c96e1b12b7617ab347ff74520af9f7c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76150e9a63a66d7b4032f10c3e2220b7bba878fa93b0b61450e7dbfbb92b0970"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffb7d9faf61ad1f572ee1ef24d6f2ccfd808308cf7c12166e55af4f521825024"
    sha256 cellar: :any_skip_relocation, catalina:      "02033fe9f7746cf8f555205ecfdec165d59a247aa9df679a410e2a08106edf99"
    sha256 cellar: :any_skip_relocation, mojave:        "1f2f213167999e8f7af999159a702a5b096163655f9f441bcf02fb9a9bf41325"
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
