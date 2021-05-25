class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.39.tar.gz"
  sha256 "446c79013680b12f3e6a52c192003dbd83af499f6149de543305f119a496d295"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2fd41d694823bd4b4c6ef8b8df178848b189481eedae91a4e3a1138327944b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebe2bb1c77eda2829aa96c6dc1398072f096bec35419eb5ec45f92eee39a36ca"
    sha256 cellar: :any_skip_relocation, catalina:      "e8e2090a0eb1d0ad3c83ffc184973519328a60b0dc082435bb48f44ed336c4e0"
    sha256 cellar: :any_skip_relocation, mojave:        "f84e82b513a0ce7baf3203d5e180894be36b309c16ff2498a293852eb7b66bfe"
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
