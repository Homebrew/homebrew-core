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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7477120fd937846557c1ae63e2f5132a127b63b6a3b11b4de0dd5cae963936b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0f237bc2f505bb186c7f1fb956fca7907097305d2ea3fa782acc11dc8785ffa"
    sha256 cellar: :any_skip_relocation, catalina:      "9117a40dfbce0003fa8899ac9d71c950be74beeaa492ac1492ea99c8f5453fa1"
    sha256 cellar: :any_skip_relocation, mojave:        "58c492aff5bd0a28a3afd3bc21d6c6ec35341ed078fe6449dc5c7470cb216138"
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
