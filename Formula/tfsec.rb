class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.20.tar.gz"
  sha256 "5789de7086f86e2da243f8e8a5039ac82900426e538eeb71559fb2fe032520f3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efe4619496a6be0fa63b1d709bd3b9fef41c87071413e5e41bea63832d9f0548"
    sha256 cellar: :any_skip_relocation, big_sur:       "659f235eed737d6f52c31ddc730907e7ead4fea4718509a1ff7e45b5269a3304"
    sha256 cellar: :any_skip_relocation, catalina:      "ba68b3d61a059c9aff1c80703df4d620ae573fc825566cbe6e131c1645461d3a"
    sha256 cellar: :any_skip_relocation, mojave:        "c3a814ac3604f51ff1ccdcc7a9630c7881f159fe67f820706557f4855bdf9368"
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
