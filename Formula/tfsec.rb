class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.29.tar.gz"
  sha256 "73efb460530a9408f3dd28e480e1a88c8aa5d1dc38ce2182e76addcf26f5687e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "948bfb79517e56fdda8196421a1c455b6b37832918ffa78c452d0db82120f598"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fd80fc528aafd81bd91ee524ac12d73bb385b1914e920f1bb583f4519601ab6"
    sha256 cellar: :any_skip_relocation, catalina:      "efeb6a0a64b4b051790be5248189a4e79d8c78facdc278a97f3dd7fe31d34a01"
    sha256 cellar: :any_skip_relocation, mojave:        "e69a722bd1fa6ef85ba123dad08f431296610e22d454b3050c8f43d9802c3f0c"
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
