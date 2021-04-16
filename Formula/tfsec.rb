class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.21.tar.gz"
  sha256 "2f3dcf40e65079e55f125e7f8f6cc94565469f34c27d77d0b460beb4ade3e644"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7e5f069cc1e3ea010fd081c56d486efbfdca999f8fc51291848d5344709de31"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0f6f0c04432bbfe33520766c8bfb53534bc7430850e0a9559e00c12bc3e08fa"
    sha256 cellar: :any_skip_relocation, catalina:      "ff16bc9e0287913c9663064964539ac2550f38087ab320e775f176add03c0356"
    sha256 cellar: :any_skip_relocation, mojave:        "c07c3e3528440b84fc361c8c9a9a7d13c0a5c02124ed02280076f6ba118c0edc"
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
