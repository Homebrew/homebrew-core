class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.16.tar.gz"
  sha256 "eeb66032dae424016e9f2c765349b2eafc77e5d12e1956840e1c538b74dad620"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14a436dcbc9ea293f5c7d680f45d49667e93ca2b56604be6de7fefe0ce12a49b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2808c5a064a213cb53b6bbc1717c72a3ed9f63ee7b4bf9a2a2a10f79f79124d"
    sha256 cellar: :any_skip_relocation, catalina:      "07f286264332cf7114d0f185e9ef0d9cfaa073ff9fe26451bad6ec54ac82a50b"
    sha256 cellar: :any_skip_relocation, mojave:        "b12e798188fde0977bc7ed4240ed340f0f4e6a886a4686cd41ce21dfcebde5e9"
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
