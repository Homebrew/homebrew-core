class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.5.tar.gz"
  sha256 "1c88fe56a4707b3f6bf47abe4783cb6d2fe3b47448f31d53b5b46a9694f11827"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b92483aeb4365010d817d08865fdd1453ea0cca515347b90427616d5e02b1966"
    sha256 cellar: :any_skip_relocation, big_sur:       "830b6078aba629c1b1dc55a03453efe7eb8c19b6eb398b67c8558cb92911dc54"
    sha256 cellar: :any_skip_relocation, catalina:      "0e8a228dc4f8b2d6862eca003e2e269a21e9a0afcdf29d59b85d777a4a59b5ad"
    sha256 cellar: :any_skip_relocation, mojave:        "1edcf9f34265135d5c057b1e6fb8db2d954bf661007057c7ce928348fb86b987"
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
