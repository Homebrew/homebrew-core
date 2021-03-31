class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.15.tar.gz"
  sha256 "a11dacc5ce7af01f2cbbb34fb5431c644b7695f7891a42ec8d49aec2b89b989a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b37898a603be618c0cfdc9527e641e7cb0a31aee94fda85a1be29f4c67625ee3"
    sha256 cellar: :any_skip_relocation, big_sur:       "3dc707bc8eebd301aa8da39b17d644d30f8dfaca592521232a4b98fff935afdf"
    sha256 cellar: :any_skip_relocation, catalina:      "84d195a6a3b6dbe5032782558c029fa6d2c6aa34805b5ff5d86cfaba25e7b243"
    sha256 cellar: :any_skip_relocation, mojave:        "de65463d314c3b99b9c5948300949f11997540140982ef86f51e26155b340862"
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
    assert_no_match(/WARNING/, good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
